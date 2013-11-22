require "spec_helper"

require_relative "../app"
require_relative "../lib/contents"

here = File.expand_path File.dirname(__FILE__)
real_sites_dir = File.expand_path "#{here}/../sites"

describe Contents do
  before do
    @meals_toc = Contents.new(site_name: 'meals', site_dir: "#{here}/sites/meals", page_name: 'prepare_a_meal')
  end

  describe "absolute links" do
    before do
      docs_toc = Contents.new(site_name: 'docs', site_dir: "#{real_sites_dir}/docs", page_name: 'docs')
      @toc_html = Nokogiri.parse(docs_toc.to_html)
    end

    it "should render absolute links absolutely" do
      links = @toc_html.css('a').inject({}) { |hsh, link| hsh[link.text] = link.attr('href'); hsh }
      links['Intro To Rails'].should == '/intro-to-rails'
    end
  end

  describe 'capitalization' do
    before do
      docs_toc = Contents.new(site_name: 'installfest', site_dir: "#{real_sites_dir}/installfest", page_name: 'installfest')
      @toc_html = Nokogiri.parse(docs_toc.to_html)
    end

    it 'capitalizes OS X' do
      links = @toc_html.css('a').inject({}) { |hsh, link| hsh[link.text] = link.attr('href'); hsh }
      links['OS X RVM'].should == '/installfest/osx_rvm'
    end
  end

  it "scans for subpage links" do
    @meals_toc.subpages.should == {
      "breakfast"=>[],
      "clean_up"=>[],
      "eat_a_meal"=>[],
      "find_some_vegetables"=>[],
      "meals"=>["breakfast"],
      "omnivorous"=>[],
      "orphaned_page"=>[],
      "prepare_a_meal"=>["vegetarian", "omnivorous"],
      "vegetarian"=>["find_some_vegetables"],
    }
  end

  it "scans for next-page connections between pages" do
    @meals_toc.nextpages.should == {
      "breakfast"=>nil,
      "clean_up"=>nil,
      "eat_a_meal"=>"clean_up",
      "find_some_vegetables"=>"eat_a_meal",
      "meals"=>"prepare_a_meal",
      "omnivorous"=>"eat_a_meal",
      "orphaned_page"=>nil,
      "prepare_a_meal"=>nil,
      "vegetarian"=>nil,
    }
  end

  it "knows the next logical page for a given page" do
    @meals_toc.find_next_page('meals').should == 'prepare_a_meal'
    @meals_toc.find_next_page('prepare_a_meal').should == 'eat_a_meal'
  end

  it "arranges pages hierarchically" do
    @meals_toc.hierarchy.should == [
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

  it "finds orphaned pages" do
    @meals_toc.orphans.should == ["orphaned_page"]
  end

  it "renders the current page as bold text, all others as links" do
    toc_html = Nokogiri.parse(@meals_toc.to_html)

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
