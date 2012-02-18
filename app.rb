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
$: << lib

require "doc_page"
require "step_page"
require "markdown_page"
require "media_wiki_page"
require "raw_page"

class InstallFest < Sinatra::Application  # should this be Sinatra::Base instead?
  include Erector::Mixin

  def initialize 
    super
    @here = File.expand_path(File.dirname(__FILE__))
    @default_site = "installfest"
  end

  attr_reader :here
  attr_writer :default_site

  def default_site
    if (host && sites.include?(site = host.split(".").first))
      site
    else
      @default_site
    end
  end

  def host
    request && request.host
  end

  def site_dir
    "#{sites_dir}/#{params[:site]}"
  end

  def sites_dir
    "#{@here}/sites"
  end

  def sites
    Dir["#{sites_dir}/*"].map{|path| path.split('/').last}
  end

  def src
    File.read(doc_path)
  end

  def ext
    doc_path.split('.').last
  end

  def doc_path
    @doc_path ||= begin
      base = "#{site_dir}/#{params[:name]}"
      %w{step md mw}.each do |ext|
        path = "#{base}.#{ext}"
        return path if File.exist?(path)
      end
      raise Errno::ENOENT, base
    end
  end

  before do
    expires 3600, :public
  end

  get '/favicon.ico' do
    halt 404
  end

  get "/" do
    redirect "/#{default_site}"
  end

  get "/:site" do
    site_name = params[:site]
    redirect "/#{site_name}/#{site_name}"
  end

  get "/:site/:name/src" do
    begin

      RawPage.new(
      site_name: params[:site],
      doc_title: doc_path.split('/').last,
      doc_path: doc_path,
      src: src
      ).to_html
    rescue Errno::ENOENT => e
      p e
      halt 404
    end
  end

  get "/:site/:name.:ext" do
    send_file "#{site_dir}/#{params[:name]}.#{params[:ext]}"
  end

  # todo: make this work in a general way, without hardcoded 'img'
  get "/:site/img/:name.:ext" do
    send_file "#{site_dir}/img/#{params[:name]}.#{params[:ext]}"
  end

  get "/:site/:name" do
    begin

      doc_title = params[:name].split('_').map do |w|
        w == "osx" ? "OS X" : w.capitalize
      end.join(' ')

      options = {
          site_name: params[:site],
          doc_title: doc_title,
          doc_path: doc_path,
          back: params[:back],
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

