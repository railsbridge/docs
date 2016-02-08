require "spec_helper"

require_relative "../app"
require_relative "../lib/contents"

here = File.expand_path File.dirname(__FILE__)
real_sites_dir = File.expand_path "#{here}/../sites"

describe Contents do
  let(:site_name) { 'meals' }
  let(:site_dir) { File.join(here, 'sites', site_name) }  # note: locale is not currently in spec/sites
  let(:page_name) { 'prepare_a_meal' }
  before do
    @toc = Contents.new(site: Site.new(site_dir), page_name: page_name)
  end

  describe "absolute links" do
    let(:site_name) { 'docs' }
    let(:site_dir) { "#{real_sites_dir}/en/#{site_name}" }
    let(:page_name) { 'docs' }    
    before do
      @toc_html = Nokogiri.parse(@toc.to_html)
    end

    it "should render absolute links absolutely" do
      links = @toc_html.css('a').inject({}) { |hsh, link| hsh[link.text] = link.attr('href'); hsh }
      links['Intro To Rails'].should == '/intro-to-rails'
    end
  end

  describe 'capitalization' do
    let(:site_name) { 'installfest' }
    let(:site_dir) { "#{real_sites_dir}/en/#{site_name}" }
    let(:page_name) { 'installfest' }
    before do
      @toc_html = Nokogiri.parse(@toc.to_html)
    end

    it 'capitalizes OS X' do
      links = @toc_html.css('a').inject({}) { |hsh, link| hsh[link.text] = link.attr('href'); hsh }
      links['OS X RVM'].should == '/installfest/osx_rvm'
    end
  end

  it "scans for subpage links" do
    @toc.subpages.should == {
      "breakfast" => [],
      "clean_up" => [],
      "eat_a_meal" => [],
      "find_some_vegetables" => [],
      "meals" => ["breakfast"],
      "omnivorous" => [],
      "orphaned_page" => [],
      "prepare_a_meal" => ["vegetarian", "omnivorous"],
      "vegetarian" => ["find_some_vegetables"],
    }
  end

  it "scans for next-page connections between pages" do
    @toc.nextpages.should == {
      "breakfast" => nil,
      "clean_up" => nil,
      "eat_a_meal" => "clean_up",
      "find_some_vegetables" => "eat_a_meal",
      "meals" => "prepare_a_meal",
      "omnivorous" => "eat_a_meal",
      "orphaned_page" => nil,
      "prepare_a_meal" => nil,
      "vegetarian" => nil,
    }
  end

  it "knows the next logical page for a given page" do
    @toc.find_next_page('meals').should == 'prepare_a_meal'
    @toc.find_next_page('prepare_a_meal').should == 'eat_a_meal'
  end

  it "arranges pages hierarchically" do
    @toc.hierarchy.should == [
      ["meals",
       "breakfast"],
      ["prepare_a_meal",
       ["vegetarian",
        "find_some_vegetables"],
       "omnivorous"],
      "eat_a_meal",
      "clean_up"
    ]
  end

  describe "collapsing" do
    context "for a shallowly nested page" do
      let(:page_name) { 'clean_up' }
      it 'flags the page as open' do
        @toc.mark_open_and_closed(@toc.hierarchy)[:items].should == [
          [
            {:title => "meals", :collapsed => true},
            {:title => "breakfast", :collapsed => true}
          ],
          [
            {:title => "prepare_a_meal", :collapsed => true},
            [
              {:title => "vegetarian", :collapsed => true},
              {:title => "find_some_vegetables", :collapsed => true}
            ],
            {:title => "omnivorous", :collapsed => true}
          ],
          {:title => "eat_a_meal", :collapsed => true},
          {:title => "clean_up", :collapsed => false}
        ]
      end
    end

    context "for a deeply nested page" do
      let(:page_name) { 'find_some_vegetables' }

      it "flags the page and all its parents as open" do
        @toc.mark_open_and_closed(@toc.hierarchy)[:items].should == [
          [
            {:title => "meals", :collapsed => true},
            {:title => "breakfast", :collapsed => true}
          ],
          [
            {:title => "prepare_a_meal", :collapsed => false},
            [
              {:title => "vegetarian", :collapsed => false},
              {:title => "find_some_vegetables", :collapsed => false}
            ],
            {:title => "omnivorous", :collapsed => true}
          ],
          {:title => "eat_a_meal", :collapsed => true},
          {:title => "clean_up", :collapsed => true}
        ]
      end
    end
  end

  it "finds orphaned pages" do
    @toc.orphans.should == ["orphaned_page"]
  end

  it "renders the current page as bold text, all others as links" do
    toc_html = Nokogiri.parse(@toc.to_html)

    current_page = toc_html.css(".current").first.text
    current_page.should == 'Prepare A Meal'

    other_pages = toc_html.css('a').map(&:text)
    other_pages.should =~ [
      "Breakfast",
      "Clean Up",
      "Eat A Meal",
      "Find Some Vegetables",
      "Meals",
      "Omnivorous",
      "Orphaned Page",
      "Vegetarian"
    ]
  end
end
