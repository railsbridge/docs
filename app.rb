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
lib = File.expand_path "#{here}/lib"
$:<<lib
require "doc_page"
require "step_page"
require "markdown_page"
require "media_wiki_page"
require "raw_page"

class InstallFest < Sinatra::Application
  include Erector::Mixin

  def initialize
    super
    @here = File.expand_path(File.dirname(__FILE__))
  end

  attr_reader :here

  def case_dir
    "#{@here}/cases/#{params[:case]}"
  end

  def src
    File.read(doc_path)
  end

  def ext
    doc_path.split('.').last
  end

  def doc_path
    @doc_path ||= begin
      base = "#{case_dir}/#{params[:name]}"
      %w{step md mw}.each do |ext|
        path = "#{base}.#{ext}"
        return path if File.exist?(path)
      end
      raise Errno::ENOENT, base
    end
  end

  get '/favicon.ico' do
    halt 404
  end

  get "/" do
    redirect "/installfest"
  end

  get "/:case" do
    case_name = params[:case]
    redirect "/#{case_name}/#{case_name}"
  end

  get "/:case/:name/src" do
    begin

      RawPage.new(
      case_name: params[:case],
      doc_title: doc_path.split('/').last,
      doc_path: doc_path,
      src: src
      ).to_html
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

      options = {
          case_name: params[:case],
          doc_title: doc_title,
          doc_path: doc_path,
          src: src,
      }

      case ext
      when "md"
        MarkdownPage.new(options).to_html

      when "mw"
        MediaWikiPage.new(options).to_html

      when "step"
        StepPage.new(options).to_html

      else
        raise "unknown file type #{doc_path}"
      end

    rescue Errno::ENOENT => e
      p e
      halt 404
    end
  end
end

