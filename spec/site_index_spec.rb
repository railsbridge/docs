here = File.expand_path File.dirname(__FILE__)
require "#{here}/spec_helper"

require "#{here}/../app"
require "#{here}/../lib/site_index"

describe Contents do
  before :all do
    @site_index = SiteIndex.new(site_name: 'frontend')
  end

  it "lists all sites in the /sites/ directory, sorted, except 'es'" do
    @site_index.sites.should =~ ["curriculum", "frontend", "installfest", "intermediate-rails", "workshop"]
  end

  it "emboldens the current site, links other sites" do
    index_html = Nokogiri.parse(@site_index.to_html)

    current_site = index_html.css("li.current").first.text
    current_site.should == 'frontend'

    other_sites = index_html.css('a').map(&:text)
    other_sites.should =~ (@site_index.sites - ['frontend'])
  end
end
