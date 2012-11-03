here = File.expand_path File.dirname(__FILE__)
require "#{here}/spec_helper"

require "#{here}/../app"
require "#{here}/../lib/site_index"

describe Contents do
  before :all do
    @site_index = SiteIndex.new
  end

  it "lists all sites in the /sites/ directory, sorted, except 'es'" do
    @site_index.sites.should == ["curriculum", "frontend", "installfest", "workshop"]
  end
end
