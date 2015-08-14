require "spec_helper"

require_relative "../app"
require "rack/test"

# todo: use a dummy set of sites instead of the real "installfest" and "curriculum"

# Here we need to use a trick to get ahold of the real Sinatra app instance
# because Sinatra uses dup on every call
class ::InstallFest
  def dup *args
    @@latest_instance = super
  end

  def self.latest_instance
    @@latest_instance
  end
end

describe InstallFest do
  include Rack::Test::Methods # see http://www.sinatrarb.com/testing.html

  def app
    InstallFest
  end

  # find the actual InstallFest app, discarding Rack middleware
  def true_app
    InstallFest.latest_instance
  end

  def get! *args
    get *args
    follow_redirect! while last_response.redirect?
    expect(last_response.status).to eq(200)
  end

  it "is a sinatra app" do
    get '/'
    expect(true_app).to be_a(InstallFest)
    expect(true_app.class.ancestors).to include(Sinatra::Application)
  end

  it "redirects / to the default site" do
    get! "/"
    expect(last_request.path).to eq("/docs/")
  end

  it "redirects /site to /site/" do
    get! "/installfest"
    expect(last_request.path).to eq("/installfest/")
  end

  it "redirects /site/page/ to /site/page" do
    get! "/installfest/linux/"
    expect(last_request.path).to eq("/installfest/linux")
  end

  it "has a default site" do
    expect(true_app.default_site).to eq("docs")
  end

  describe "settings" do
    # note: I'd rather pass settings into the constructor, but Sinatra uses that interface (for a downstream app)

    before { get '/' }

    describe "learns the locale from" do
      it "the locale parameter" do
        true_app.params = {locale: 'es'}
        expect(true_app.dynamic_locale).to eq('es')
      end

      it "the l parameter" do
        true_app.params = {l: 'es'}
        expect(true_app.dynamic_locale).to eq('es')
      end

      it "the subdomain" do
        true_app.request = Rack::Request.new({"HTTP_HOST" => "es.example.com"})
        expect(true_app.dynamic_locale).to eq('es')
      end

      it "the SITE_LOCALE environment var" do
        begin
          ENV["SITE_LOCALE"] = "es"
          expect(true_app.dynamic_locale).to eq('es')
        ensure
          ENV["SITE_LOCALE"] = nil
        end
      end
    end
  end

  it "looks for a site named the same as the host" do
    get "/", {}, {"HTTP_HOST" => "docs.example.com"}
    expect(last_response).to be_redirect
    follow_redirect! while last_response.redirect?
    expect(last_request.path).to eq("/docs/")
  end

  describe "in the 'es' locale" do
    it "uses the 'es' subdir as the sites_dir" do
      get "/", locale: "es"

      es_dir = File.expand_path(File.join(__FILE__, "..", "..", "sites", "es"))
      expect(true_app.sites_dir).to eq(es_dir)
    end

  end

  describe "page headers" do
    before :all do
      get "/"
      follow_redirect! while last_response.redirect?
      @body = last_response.body
    end

    it "should contain the html5 doctype" do
      @body.should match(/<!doctype html>/i)
    end
  end
end
