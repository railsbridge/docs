require 'titleizer'

class Contents < Erector::Widget
  attr_accessor :site_dir
  attr_accessor :page_name
  # todo: replace site_name, locale, site_dir with Site object
  needs :page_name, :site_name, :locale => nil, :site_dir => nil

  def initialize options
    super options

    self.page_name = options[:page_name]

    if options.include? :site_dir  # used in tests
      @site_dir = options[:site_dir]
    else
      site = Site.named(@site_name, @locale)
      @site_dir = site.dir if site
    end
  end

  def site_files ext
    Dir.glob("#{site_dir}/*.{#{ext}}").sort
  end

  def parseable_site_files
    site_files("mw,md,step")
  end

  def site_page_files
    parseable_site_files.reject { |file| File.basename(file).start_with?('_') }
  end

  def content_for filename
    open("#{site_dir}/#{filename}").read
  end

  def subpages_for filename
    links = []
    return links if filename.match(/deck\.md/)
    content = content_for(filename)

    # (markdown) links of the form: [link text](link_page)
    # but NOT images of the form ![alt text](image_link.jpg)
    content.scan /[^!]\[.*?\]\((.*?)\)/ do |link, _|
      next if (link =~ /^http/)
      next if (link =~ %r(^//)) # protocol-less absolute links e.g. //google.com
      links.push(link)
    end

    # (stepfiles) links of the form: link "next page"
    content.scan /link\s*["'](.*?)["']/ do |link, _|
      links.push(link)
    end

    # (stepfiles) links of the form: site_desc "some site"
    content.scan /site_desc\s*["'](.*?)["']/ do |link, _|
      links.push('/' + link)
    end

    links.uniq
  end

  def next_step_for filename
    content = content_for(filename)

    # (stepfiles) links of the form: stepfile "next page"
    content.scan /next_step\s*["'](.*?)["']/ do |link, _|
      return link
    end

    return nil
  end

  def collect_subpages page
    if subpages[page] and !subpages[page].empty?
      return [page] + subpages[page].map { |subpage| collect_subpages subpage }
    end

    return page
  end

  def find_next_page page
    return nextpages[page] if nextpages[page]

    if subpages[page]
      return subpages[page].map { |subpage| find_next_page subpage }.compact.first
    end

    return nil
  end

  # Generate an array of pages on this site arranged hierarchically.
  #
  # The array is of the format:
  # [
  #   "root_page",
  #   ["second_page",
  #     "subpage_of_second_page",
  #     "another_subpage_on_the_same_level"],
  #   ["third_page",
  #     ["subpage_of_third_page",
  #       "subpage_of_subpage_of_third_page"]],
  #   "fourth page"
  # ]
  # ... and so on
  # This code assumes that a site is a linearly ordered series of pages
  #   linked by "next_step" declarations.
  # Each page can contain many subpages, and the "next_step" for the outer page
  #   may be hidden deeply within the tree, but it must be there and it must be
  #   unique (one side of the subtree branch shouldn't go to next_step "this"
  #   while another goes to next_step "that").
  def hierarchy
    result = []
    next_page = File.basename(site_dir)
    while next_page do
      this_page = next_page

      result.push(collect_subpages this_page)

      next_page = find_next_page this_page
    end
    result
  end

  def all_pages
    site_page_files.map { |file| File.basename(file).sub(/(\..*)$/, '') }.sort
  end

  def orphans
    all_pages - hierarchy.flatten.uniq
  end

  def _page_links type="subpages"
    site_page_files.inject({}) do |result, filename|
      page = File.basename(filename)
      page_no_ext = page.sub(/(\..*)$/, '')
      result[page_no_ext] = send("#{type}_for", page)
      result
    end
  end

  def subpages
    @subpages ||=  _page_links("subpages")
  end

  def nextpages
    @nextpages ||= _page_links("next_step")
  end

  def _toggler
    span(class: 'toggler') do
      i(class: 'fa fa-plus-square-o')
      i(class: 'fa fa-minus-square-o')
    end
  end

  def toc_link page, options = {}
    link_text = Titleizer.title_for_page(page.sub(%r{^/}, ''))
    path = page.start_with?('/') ? page : "/#{@site_name}/" + page
    collapse_classes = if options[:collapsable]
                         options[:collapsed] ? 'collapsable closed' : 'collapsable'
                       else
                         ''
                       end
    li(class: collapse_classes) do
      if page == page_name
        _toggler if options[:collapsable]
        span link_text, class: 'current'
      else
        a href: path do
          _toggler if options[:collapsable]
          text link_text
        end
      end
      yield if block_given?
    end
  end

  # Given the nested set of arrays produced by the 'hierarchy' method above,
  # annotate each item noting whether it should be collapsed
  # An element is 'collapsed' if it does not contain the page currently
  # being viewed.
  def mark_open_and_closed hierarchy
    result = {items: [], contains_current_page: false}
    hierarchy.each do |toc_item|
      contains_current_page = nil
      if toc_item.instance_of? Array
        parent = toc_item[0]
        children = toc_item[1..toc_item.length]
        inner_result = mark_open_and_closed(children)
        contains_current_page = (self.page_name == parent) || inner_result[:contains_current_page]
        result[:items] << [{title: parent, collapsed: !contains_current_page}] + inner_result[:items]
      else
        contains_current_page ||= (self.page_name == toc_item)
        result[:items] << {title: toc_item, collapsed: !contains_current_page}
      end
      result[:contains_current_page] ||= contains_current_page
    end
    result
  end

  def toc_list toc_items, level = 0
    ul do
      toc_items.each do |toc_item|
        if toc_item.instance_of? Array
          item = toc_item.first
          toc_link item[:title], collapsable: true, collapsed: item[:collapsed] do
            toc_list toc_item[1..toc_item.length], level + 1
          end
        else
          toc_link toc_item[:title]
        end
      end
    end
  end

  def has_collapsables toc_items
    toc_items.any? do |toc_item|
      if toc_item.instance_of? Array
        return true
      end
    end
  end

  def content
    div id: "table_of_contents", class: "toc page-list" do
      toc_list(mark_open_and_closed(hierarchy)[:items])

      unless orphans.empty?
        h1 I18n.t("general.other_pages")
        ul do
          orphans.each { |orphan| toc_link orphan }
        end
      end

      if has_collapsables(hierarchy)
        span class: "expand-all" do
          i class: "fa fa-arrows-alt"
          text I18n.t("general.expand_all")
        end
      end
    end
  end
end
