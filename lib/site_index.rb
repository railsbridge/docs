class SiteIndex < Erector::Widget
  needs :site_name, :locale
  attr_accessor :site_name

  def categorized_sites
    {
      'setup' => ['installfest'],
      'rails' => ['intro-to-rails', 'job-board', 'message-board'],
      'frontend' => ['frontend', 'javascript-snake-game', 'javascript-to-do-list', 'javascript-to-do-list-with-react'],
      'ruby' => ['learn-to-code', 'ruby']
    }
  end

  def sites
    return @sites if @sites
    @sites = Dir.glob("#{Site.sites_dir(@locale)}/**").map { |filename| File.basename(filename) }.sort
  end

  def site_category category
    li Titleizer.title_for_page(category), class: 'category'
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
      categorized_sites.each do |category, category_sites|
        site_category category
        category_sites.each do |site|
          site_link site
        end
      end
      site_category I18n.t('sites.other_categories')
      (sites - categorized_sites.values.flatten).each do |site|
        site_link site
      end
    end
  end
end
