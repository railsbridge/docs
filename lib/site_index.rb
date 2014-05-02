class SiteIndex < Erector::Widget
  @@order = {"docs" => -1, "installfest" => 0, "intro" => 1, "intermediate" => 2, "advanced" => 3}

  needs :site_name, :locale
  attr_accessor :site_name

  def sites
    return @sites if @sites
    @sites = Dir.glob("#{Site.sites_dir(@locale)}/**").map { |filename| File.basename(filename) }.sort do |a,b|
      a_word = a.split(/[-_]/, 0)[0].downcase
      b_word = b.split(/[-_]/, 0)[0].downcase
      # One or more words are unknown
      case
        when (!@@order.key?(a_word) && !@@order.key?(b_word))
          # Both unknown, so compare to each other
          a <=> b
        when (!@@order.key?(a_word) && @@order.key?(b_word))
          # Unknown are higher precedence than all known
          1
        when (@@order.key?(a_word) && !@@order.key?(b_word))
          # Opposite of above
          -1
        # Both are known
        when @@order[a_word] == @@order[b_word]
          # Both have the same order so compare to each other
          a <=> b
        when @@order[a_word] < @@order[b_word]
          # Left has lower order than right
          -1
        else
          # Right has lower order then left
          1
      end
    end
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
