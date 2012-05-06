
class Contents < Erector::Widget
  attr_accessor :site_dir
  needs :site_name, :site_dir => nil

  def initialize options
    super options

    if options.include? :site_dir
      self.site_dir = options[:site_dir]
    else
      here = File.expand_path File.dirname(__FILE__)
      top = File.expand_path "#{here}/.."
      self.site_dir = "#{top}/sites/#{@site_name}"
    end
  end

  def site_files ext
    Dir.glob("#{site_dir}/*.{#{ext}}").sort
  end

  def subpages_for filename
    links = []
    content = open("#{site_dir}/#{filename}").read()

    # (markdown) links of the form: [link text](link_page)
    content.scan /\[.*?\]\((.*?)\)/ do |link, _|
      next if (link =~ /^http/)
      next if (link =~ /(jpg|png)$/)
      links.push(link) if !links.include? link
    end

    # (stepfiles) links of the form: link "next page"
    content.scan /link\s*["'](.*?)["']/ do |link, _|
      links.push(link) if !links.include? link
    end

    links
  end

  def next_step_for filename
    content = open("#{site_dir}/#{filename}").read()

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
    site_files("mw,md,step").map { |file| File.basename(file).sub(/(\..*)$/, '') }.sort
  end

  def orphans
    all_pages - hierarchy.flatten.uniq
  end

  def _page_links type="subpages"
    site_files("mw,md,step").inject({}) do |result, filename|
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

  def create_link page
    link_text = page.split('_').map{|s|s.capitalize}.join(' ')
    path = "/#{@site_name}/" + page
    li { a(link_text, :href => path) }
  end

  def create_list toc_items
    ul do
      toc_items.each do |toc_item|
        if toc_item.instance_of? Array
          create_link toc_item.first
          create_list toc_item[1..toc_item.length]
        else
          create_link toc_item
        end
      end
    end
  end

  def content
    div class: "toc" do
      h1 "Contents"
      create_list hierarchy

      unless orphans.empty?
        h1 "Other Pages"
        ul do
          orphans.each { |orphan| create_link orphan }
        end
      end

      h1 "Images"
      ul do
        site_files("jpg,png").each do |path|
          title = File.basename(path)
          path = path.gsub(/^#{site_dir}\//, '')
          li { a(title, :href => path) }
        end
      end
    end
  end
end
