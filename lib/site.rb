class Site
  DOC_TYPES = %w{step md deck.md mw}

  @@here = File.expand_path(File.dirname(__FILE__))
  @@project_root = File.dirname(@@here)

  def self.sites_dir locale = "en"
    sites_dir = File.join(["sites", locale.to_s].compact)
    File.expand_path(sites_dir, @@project_root)
  end

  def self.all locale = "en"
    Dir["#{sites_dir(locale)}/*"].map{|dir| Site.new(dir)}
  end

  def self.named name, locale = "en"
    all(locale).detect{|site| site.name == name }
  end

  attr_reader :dir

  def initialize dir
    @dir = dir
  end

  def name
    @dir.split('/').last
  end

  def docs
    Dir["#{@dir}/*.{#{DOC_TYPES.join(',')}}"].map{|path| Doc.new(path)}
  end

  class Doc
    attr_reader :path

    def initialize path
      @path = path
    end

    def filename
      @path.split('/').last
    end

    def name
      filename.split('.').first
    end

  end
end
