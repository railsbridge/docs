class Site
  @@here = File.expand_path(File.dirname(__FILE__))
  @@project_root = File.dirname(@@here)
  @@sites_dir = File.expand_path("sites", @@project_root)

  def self.all
    Dir["#{@@sites_dir}/*"].map{|dir| Site.new(dir)}
  end
  
  def self.named name
    all.detect{|site| site.name == name }
  end
  
  DOC_TYPES = %w{step md deck.md mw}
  
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
