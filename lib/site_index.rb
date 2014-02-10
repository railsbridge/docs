class SiteIndex < Erector::Widget
  needs :site_name, :locale
  attr_accessor :site_name

  def sites
    return @sites if @sites
    @sites = Dir.glob("#{Site.sites_dir(@locale)}/**").map { |filename| File.basename(filename) }.sort
  end

  def site_link site
    if site == site_name
      return li Titleizer.title_for_page(site_name), class: 'current'
    end

    path = "/#{site}/"
    li do
      a(Titleizer.title_for_page(site), :href => path)
    end
  end

  def content
    ul :class => "dropdown-menu" do
      sites.each do |site|
        site_link site
      end
    end
  end
end
