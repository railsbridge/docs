class Site
  DOC_TYPES = %w[step md deck.md mw].freeze

  @@here = __dir__
  @@project_root = File.dirname(@@here)

  def self.sites_dir
    File.expand_path('sites', @@project_root)
  end

  def self.all
    Dir[File.join(sites_dir, '*')].map { |dir| Site.new(dir) }
  end

  def self.named(name)
    site = all.detect { |folder| folder.name == name }
    raise "No site found with the name '#{name}'" unless site

    site
  end

  attr_reader :dir

  def initialize(dir)
    @dir = dir
  end

  def name
    @dir.split('/').last
  end

  def docs
    file_path_glob = File.join(@dir, "*.{#{DOC_TYPES.join(',')}}")
    Dir[file_path_glob].map { |path| Doc.new(path) }
  end

  class Doc
    attr_reader :path

    def initialize(path)
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
