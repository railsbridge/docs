class Site
  DOC_TYPES = %w{step md deck.md mw}

  @@here = File.expand_path(File.dirname(__FILE__))
  @@project_root = File.dirname(@@here)

  def self.sites_dir locale = "en"
    sites_dir = File.join(["sites", locale.to_s].compact)
    File.expand_path(sites_dir, @@project_root)
  end

  def self.all locale = "en"
    Dir[File.join(sites_dir(locale), '*')].map{|dir| Site.new(dir)}
  end

  def self.named name, locale = "en"
    site = all(locale).detect { |site| site.name == name }
    raise "No site found with the name '#{name}' in locale '#{locale}'" unless site
    site
  end

  attr_reader :dir

  def initialize dir
    @dir = dir
  end

  def name
    @dir.split('/').last
  end

  def docs
    file_path_glob = File.join(@dir, "*.{#{DOC_TYPES.join(',')}}")
    Dir[file_path_glob].map{|path| Doc.new(path)}
  end

  class Doc
    attr_reader :path

    def initialize path
      @path = path
    end

    def filename
      File.basename(@path)
    end

    def name
      filename.split('.').first
    end

  end
end
