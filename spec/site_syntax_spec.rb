require "spec_helper"
require_relative "../app"

require "site"

require "rack/test"

describe "Syntax check all sites" do
  include Rack::Test::Methods

  def app
    @app ||= InstallFest.new
  end

  ['en', 'es'].each do |locale|
    describe "in locale '#{locale}'" do
      Site.all(locale).each do |site|
        describe "#{site.name} pages..." do
          site.docs.each do |doc|
            it "renders #{doc.filename}" do
              path = "/#{site.name}/#{doc.name}"
              get path, locale: locale
              if (last_response.status != 200)
                errors = last_response.errors
                meaningful_errors = errors.each_line.select do |l|
                  l.include? path or l !~ %r{^\t}
                end.join
                puts "#{path}: #{meaningful_errors}"
                fail("Syntax errors in #{path} -- see above")
              end

              last_response_status = last_response.status
              assert { last_response_status == 200 }

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
