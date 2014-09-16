require "spec_helper"

require_relative "../app"
require "rack/test"

describe InstallFest do
  include Rack::Test::Methods

  # todo: move to shared module
  def get! *args
    get *args
    assert { last_response.status == 200 }
  end

  def app
    Rack::Builder.parse_file(File.join(File.dirname(__FILE__), '..', 'config.ru')).first
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

      sites_dir = dir "sites"  do
          dir "meals" do
            file "breakfast.deck.md", breakfast
          end
      end
      Site.stub(:sites_dir) { sites_dir }

      @breakfast = breakfast
    end

    it "renders a deck" do
      get! "/meals/breakfast"
      # rendered_breakfast = Deck::SlideDeck.new(:slides => Deck::Slide.split(@breakfast)).to_pretty  # for some reason it's not rendering pretty from the app even though the app uses .to_pretty
      assert { last_response.body.include? "Raisin Bran" }
    end

    # todo: include deck.js source right inside the HTML
    it "serves up deck.js and other public assets" do
      get! "/deck.js/core/deck.core.js"
      assert { last_response.body.include?("Deck JS - deck.core")}

      get! "/deck.js/jquery-1.7.2.min.js"
      assert { last_response.body.include?("jQuery v1.7.2 jquery.com")}

      get! "/assets/application.css"
      assert { last_response.body.include?("/* Code ray css */")}
    end
  end
end