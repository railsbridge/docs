here = File.expand_path File.dirname(__FILE__)
require "#{here}/spec_helper"
require "#{here}/../app"
require "site"

require "rack/test"

# todo: use a dummy set of sites instead of the real "installfest" and "curriculum"

describe InstallFest do
  include Rack::Test::Methods

  def app
    @app ||= InstallFest.new
  end

  def get! *args
    get *args
    assert { last_response.status == 200 }
  end

  describe "checking pages..." do
    Site.all.each do |site|
      site.docs.each do |doc|
        it "renders #{doc.filename}" do
          get! "/#{site.name}/#{doc.name}"
          assert { last_response.ok? }
        end
      end
    end
  end

end
