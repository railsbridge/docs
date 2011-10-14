# http://daringfireball.net/projects/markdown/syntax#img
# http://www.wiki.devchix.com/index.php?title=Help:Editing
puts RUBY_VERSION

require 'sinatra'
require 'digest/md5'
require 'erector'
# require 'wrong'
# include Wrong::D

begin
  require 'rdiscount'
rescue LoadError
  require 'bluecloth'
  Object.send(:remove_const,:Markdown)
  Markdown = BlueCloth
end

here = File.expand_path File.dirname(__FILE__)
require "./media_wiki"
require "./markdown_page"
require "./contents"

class InstallFest < Sinatra::Application
  include Erector::Mixin
  include MediaWiki
  
  def initialize
    super
    @here = File.expand_path(File.dirname(__FILE__))
  end
  
  attr_reader :here

  def case_dir
    "#{@here}/cases/#{params[:case]}"
  end

  def src
    base = "#{case_dir}/#{params[:name]}"
    File.read("#{base}.md")
  rescue Errno::ENOENT
    mw2md File.read("#{base}.mw")
  end

  get "/" do
    redirect "/installfest/start"
  end

  get "/:case/:name/src" do
    begin
      "<pre>#{source}</pre>"
    rescue Errno::ENOENT => e
      p e
      halt 404
    end
  end
  
  get "/:case/:name.:ext" do
    send_file "#{case_dir}/#{params[:name]}.#{params[:ext]}"
  end
  
  get "/:case/:name" do
    begin
      doc_title = params[:name].split('_').map do |w| 
        w == "osx" ? "OS X" : w.capitalize
      end.join(' ')
      
      MarkdownPage.new(
        case_name: params[:case],
        doc_title: doc_title,
        markdown_src: src
      ).to_html

    rescue Errno::ENOENT => e
      p e
      halt 404
    end
  end
end

