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

  ['en', 'es'].each do |locale|
    describe "in locale '#{locale}'" do
      Site.all(locale).each do |site|
        describe "#{site.name} pages..." do
          site.docs.each do |doc|
            it "renders #{doc.filename}" do
              get! "/#{site.name}/#{doc.name}", locale: locale
              assert { last_response.ok? }
              if doc.filename.end_with?('.step')
                assert { last_response.body !~ /FUZZY/ }
              end
            end
          end
        end
      end
    end
  end

end
