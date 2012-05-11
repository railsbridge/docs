here = File.expand_path File.dirname(__FILE__)
require "#{here}/spec_helper"

require "#{here}/../app"
require "rack/test"

# todo: use a dummy set of sites instead of the real "installfest" and "curriculum"

describe InstallFest do
  include Rack::Test::Methods

  def app
    @app ||= InstallFest.new
  end

  # find the actual InstallFest app, discarding Rack middleware
  def true_app
    true_app = app
    until true_app.is_a? InstallFest
      next_app = true_app.instance_variable_get(:@app)      
      break if next_app.nil?
      true_app = next_app
    end
    true_app
  end

  it "is a sinatra app" do
    assert { true_app.is_a? InstallFest }
    assert { true_app.class.ancestors.include? Sinatra::Application }
  end

  it "redirects / to the default site" do
    get "/"
    assert { last_response.redirect? }
    follow_redirect! while last_response.redirect?
    assert { last_request.path == "/installfest/" }
  end

  it "redirects /site to /site/" do
    get "/installfest"
    follow_redirect! while last_response.redirect?
    assert { last_request.path == "/installfest/" }
  end

  it "redirects /site/page/ to /site/page" do
    get "/installfest/foo/"
    follow_redirect! while last_response.redirect?
    assert { last_request.path == "/installfest/foo" }
  end

  it "has a default site" do
    assert { true_app.default_site == "installfest" }
  end

  describe "settings" do
    # note: I'd rather pass settings into the constructor, but Sinatra uses that interface (for a downstream app)

    it "accepts default_site via setter" do
      true_app.default_site = "curriculum"
      assert { true_app.default_site == "curriculum" }
    end

    it "accepts default_site via Sinatra set" do
      pending "figure out Sinatra set"
      InstallFest.set :default_site, "curriculum"
      @app = InstallFest.new
      assert { true_app.default_site == "curriculum" }
    end

    it "can configure the sites_dir" do
      foo_dir = dir "foo"
      true_app.sites_dir = foo_dir
      assert { true_app.sites_dir == foo_dir }
    end
  end

  it "looks for a site named the same as the host" do
    get "/", {}, {"HTTP_HOST" => "curriculum.example.com"}
    assert { last_response.redirect? }
    follow_redirect! while last_response.redirect?
    assert { last_request.path == "/curriculum/" }
  end

  describe "an app with slides" do
    require "deck"
    before do
      breakfast = <<-MARKDOWN
# Eggs

* scrambled
* fried

# Cereal

* Frosted Mini-Wheats
* Corn Flakes
* Raisin Bran
      MARKDOWN

      true_app.sites_dir = dir "sites"  do
        dir "meals" do
          f = file "breakfast.deck.md", breakfast
        end
      end
      @breakfast = breakfast
    end
    
    def get! *args
      get *args
      assert { last_response.status == 200 }
    end
    
    it "renders a deck" do
      get! "/meals/breakfast"
      rendered_breakfast = Deck::SlideDeck.new(:slides => Deck::Slide.split(@breakfast)).to_pretty      
      assert { last_response.body.include?(rendered_breakfast) }
    end
    
    # todo: include deck.js source right inside the HTML
    it "serves up deck.js and other public assets" do
      get! "/deck.js/core/deck.core.js"
      assert { last_response.body.include?("Deck JS - deck.core")}

      get! "/deck.js/jquery-1.7.min.js"
      assert { last_response.body.include?("jQuery v1.7 jquery.com")}

      get! "/coderay.css"
      assert { last_response.body.include?("/* Code ray css */")}
    end
      
  end

end
