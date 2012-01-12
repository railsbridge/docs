here = File.expand_path File.dirname(__FILE__)
require "#{here}/spec_helper"

require "#{here}/../app"
require "rack/test"

describe InstallFest do
  include Rack::Test::Methods
  
  def app
    InstallFest.new
  end
  
  it "is a sinatra app" do
    assert { InstallFest.ancestors.include? Sinatra::Application }
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
  
end

