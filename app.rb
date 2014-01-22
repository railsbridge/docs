require 'sinatra'
require 'digest/md5'
require 'erector'

# require 'wrong'
# include Wrong::D

here = File.expand_path File.dirname(__FILE__)
lib = File.expand_path "#{here}/lib"
$: << lib

require "doc_page"
require "step_page"
require "markdown_page"
require "media_wiki_page"
require "raw_page"
require "deck"
require "deck/rack_app"

class InstallFest < Sinatra::Application  # should this be Sinatra::Base instead?
  include Erector::Mixin

  def initialize
    super
    @here = File.expand_path(File.dirname(__FILE__))
    @default_site = "docs"
    set_downstream_app # todo: test
  end

  attr_reader :here
  attr_writer :default_site

  def default_site
    if host
      host_parts = host.split(".")
      subdomain = host_parts.first
      if ["es"].include?(subdomain)
        params[:locale] = subdomain
        # if request.env['PATH_INFO'] = host_parts[1..-1]
        "es/" + @default_site
      elsif sites.include?(subdomain)
        subdomain
      else
        @default_site
      end
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

  def sites_dir= dir
    @sites_dir = dir.tap { set_downstream_app }
  end

  def set_downstream_app
    # todo: make this an upstream app instead?
    @app = ::Deck::RackApp.public_file_server
  end

  def sites_dir
    @sites_dir || "#{@here}/sites"
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
        %w{step md deck.md mw}.each do |ext|
        path = "#{base}.#{ext}"
        return path if File.exist?(path)
      end
      raise Errno::ENOENT, base
    end
  end

  def title_for_page page_name
    page_name.split(/[-_]/).map do |w|
      w == "osx" ? "OS X" : w.capitalize
    end.join(' ')
  end

  def render_page
    begin
      options = {
          site_name: params[:site],
          page_name: params[:name],
          doc_title: title_for_page(params[:name]),
          doc_path: doc_path,
          back: params[:back],
          src: src,
      }

      case ext

      when "md"
        if doc_path =~ /\.deck\.md$/   # todo: refactor
          # todo: render with page nav elements too
          slides = Deck::Slide.split(src)
          Deck::SlideDeck.new(:slides => slides).to_pretty
        else
          MarkdownPage.new(options).to_html
        end

      when "mw"
        MediaWikiPage.new(options).to_html

      when "step"
        StepPage.new(options).to_html

      else
        raise "unknown file type #{doc_path}"
      end

    rescue Errno::ENOENT => e
      p e
      puts "\t#{caller[0..2].join("\n\t")}"
      halt 404
    end
  end

  before do
    expires 3600, :public
  end

  get '/favicon.ico' do
    halt 404
  end

  get "/" do
    redirect "/#{default_site}/"
  end

  get "/:site/:name/src" do
    begin
      RawPage.new(
      site_name: params[:site],
      page_name: params[:name],
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
    if sites.include?(params[:site])
      send_file "#{site_dir}/#{params[:name]}.#{params[:ext]}"
    else
      forward  # send it on to the downstream file server
    end
  end

  # todo: make this work in a general way, without hardcoded 'img'
  get "/:site/img/:name.:ext" do
    if sites.include?(params[:site])
      send_file "#{site_dir}/img/#{params[:name]}.#{params[:ext]}"
    else
      forward  # send it on to the downstream file server
    end
  end

  get "/:site/:name/" do
    # remove any extraneous slash from otherwise well-formed page URLs
    redirect "#{params[:site]}/#{params[:name]}"
  end

  get "/:site/:name" do
    if params[:site] == "es"
      params[:site] = "es/#{params[:name]}"
    end
    render_page
  end

  get "/:site/:name/:section/" do
    # remove any extraneous slash from otherwise well-formed page URLs
    redirect "#{params[:site]}/#{params[:name]}/#{params[:section]}"
  end

  get "/:site/:name/:section" do
    
    if params[:site] == 'deck.js'  # hack: todo: put the deck.js file server *ahead* in the rack chain
      forward
    else
      if params[:site] == "es"
        params[:site] = "es/#{params[:name]}"
        params[:name] = params[:section]
      end
      render_page
    end
  end

  get "/:file.:ext" do
    # treat root URLs with dots in them like static assets and serve them
    #   from the downstream file server (coderay.css, jquery-1.7.2.js)
    forward
  end

  get "/:site" do
    # add a slash to any URLs that contain only a site
    #   (otherwise paths in that site's pages would resolve
    #    relative to the root)
    redirect "#{params[:site]}/"
  end

  get "/:site/" do
    site_name = params[:site]
    if sites.include? site_name
      # render the site's index page
      if site_name == "es"
        params[:site] = "es/#{default_site}"
        site_name = default_site 
      end
      params[:name] = site_name
      render_page
    else
      forward  # send it on to the downstream file server
    end
  end
end
