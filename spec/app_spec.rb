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
  
  def true_app
    true_app = app
    while (next_app = true_app.instance_variable_get(:@app))
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
    assert { last_request.path == "/installfest/installfest" }
  end
  
  it "redirects /site to /site/site" do
    get "/installfest"
    follow_redirect! while last_response.redirect?    
    assert { last_request.path == "/installfest/installfest" }
  end
  
  it "has a default site" do
    assert { true_app.default_site == "installfest" }
  end
  
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
  
  it "looks for a site named the same as the host" do
    get "/", {}, {"HTTP_HOST" => "curriculum.example.com"}
    assert { last_response.redirect? }
    follow_redirect! while last_response.redirect?    
    assert { last_request.path == "/curriculum/curriculum" }
  end
  
end

