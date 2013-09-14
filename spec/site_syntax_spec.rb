require "spec_helper"
require_relative "../app"

require "site"

require "rack/test"

describe "Syntax check all sites" do
  include Rack::Test::Methods

  def app
    @app ||= InstallFest.new
  end

  def get! *args
    get *args
    assert { last_response.status == 200 }
  end

  Site.all.each do |site|
    describe "checking #{site.name} pages..." do
      site.docs.each do |doc|
        it "renders #{doc.filename}" do
          get! "/#{site.name}/#{doc.name}"
          assert { last_response.ok? }
          if doc.filename.end_with?('.step')
            assert { last_response.body !~ /FUZZY/ }
          end
        end
      end
    end
  end

end
