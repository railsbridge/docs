require 'sinatra'
require 'digest/md5'
require 'erector'

#require 'wrong'
#include Wrong::D

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
require "titleizer"
require "site"

class InstallFest < Sinatra::Application   # todo: use Sinatra::Base instead, with more explicit config
  include Erector::Mixin

  def initialize
    super
    @here = File.expand_path(File.dirname(__FILE__))
    @default_sites = {en: "docs", es: "hola"}
    @default_locale = "en"
  end

  attr_reader :here, :default_locale
  attr_writer :default_site, :default_locale

  # todo: test
  # returns the most-specific hostname component, e.g. "foo" for "foo.example.com"
  def subdomain
    host.split(".").first
  end

  def default_site
    if host && sites.include?(site = subdomain)
      site
    else
      @default_sites[locale.to_sym]
    end
  end

  def host
    request && request.host
  end

  def site_dir
    "#{sites_dir}/#{params[:site]}"
  end

  def sites_dir
    Site.sites_dir(locale)
  end

  def sites
    Dir["#{sites_dir}/*"].map { |path| path.split('/').last }
  end

  def redirect_sites
    {
      'curriculum' => 'intro-to-rails'
    }
  end

  def locale
    (params && (params[:locale] or params[:l])) or
      (host && subdomain =~ /^..$/ && subdomain) or   # note: only allows 2-char locales for now -- should check against a list of locales
      (ENV['SITE_LOCALE']) or
      default_locale
  end

  def src
    File.read(doc_path)
  end

  def ext
    ext = $1 if doc_path.match(/\.(.*)/)
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

  def render_page
    begin
      options = {
        site_name: params[:site],
        page_name: params[:name],
        doc_title: Titleizer.title_for_page(params[:name]),
        doc_path: doc_path,
        back: params[:back],
        src: src,
        locale: locale,
      }

      case ext

        when "deck.md", "deck"
          render_deck

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
      e.backtrace.each do |line|
        break if line =~ /sinatra\/base.rb/
        puts "\t"+line
      end
      halt 404
    end
  end

  def render_deck
    slides = Deck::Slide.split(src)
    Deck::SlideDeck.new(:slides => slides).to_pretty
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
        src: src,
        locale: locale,
      ).to_html
    rescue Errno::ENOENT => e
      p e
      halt 404
    end
  end

  get "/:site/:name.:ext" do
    if sites.include?(params[:site])
      if params[:ext] == "deck"  # to show a markdown page as slides, change the ".md" to ".deck"
        render_deck
      else
        send_file "#{site_dir}/#{params[:name]}.#{params[:ext]}"
      end
    end
  end

  # todo: make this work in a general way, without hardcoded 'img'
  get "/:site/img/:name.:ext" do
    if sites.include?(params[:site])
      send_file "#{site_dir}/img/#{params[:name]}.#{params[:ext]}"
    end
  end

  get "/:site/:name/" do
    # remove any extraneous slash from otherwise well-formed page URLs
    redirect request.fullpath.chomp('/')
  end

  get "/:site/:name" do
    site_name = params[:site]
    if redirect_sites[site_name]
      redirect "#{redirect_sites[site_name]}/#{params[:name]}"
    else
      render_page
    end
  end

  get "/:site/:name/:section/" do
    # remove any extraneous slash from otherwise well-formed page URLs
    redirect "#{params[:site]}/#{params[:name]}/#{params[:section]}"
  end

  get "/:site/:name/:section" do
    render_page
  end

  get "/:site" do
    # add a slash to any URLs that contain only a site
    # (otherwise paths in that site's pages would resolve relative to the root)
    redirect "#{request.fullpath}/"
  end

  get "/:site/" do
    site_name = params[:site]
    if redirect_sites[site_name]
      redirect "#{redirect_sites[site_name]}/"
    elsif sites.include? site_name
      # render the site's index page
      params[:name] = site_name
      render_page
    end
  end
end
