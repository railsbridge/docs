require 'sinatra'
require 'sinatra/cookies'
require 'digest/md5'
require 'erector'
require 'i18n'
require 'i18n/backend/fallbacks'
require 'font-awesome-sass'
require 'bootstrap-sass'
require 'zip'
require 'tmpdir'

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
require 'sprockets'
require 'jquery-cdn'

class InstallFest < Sinatra::Application   # todo: use Sinatra::Base instead, with more explicit config
  include Erector::Mixin

  DEFAULT_SITES = {en: "docs", es: "hola", :"zh-tw" => "nihao" }

  # Set available locales in Array of Strings; this is also used when
  # checking availability in dynamic locale assignment, they must be strings.
  AVAILABLE_LOCALES = DEFAULT_SITES.keys.map(&:to_s)

  set :assets, Sprockets::Environment.new
  settings.assets.append_path "assets/stylesheets"
  settings.assets.append_path "assets/javascripts"
  settings.assets.append_path "public/fonts"
  settings.assets.append_path Bootstrap.javascripts_path
  JqueryCdn.install(settings.assets)

  if settings.environment == :development
    set :cookie_options, domain: nil
  end

  configure do
    I18n::Backend::Simple.include(I18n::Backend::Fallbacks)
    I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
    I18n.backend.load_translations

    I18n.available_locales = AVAILABLE_LOCALES
    I18n.enforce_available_locales = true
    I18n.default_locale = :en
  end

  def initialize
    super
    @here = File.expand_path(File.dirname(__FILE__))
  end

  attr_reader :here
  attr_writer :default_site

  # todo: test
  # returns the most-specific hostname component, e.g. "foo" for "foo.example.com"
  def subdomain
    host.split(".").first
  end

  def default_site
    if host && sites.include?(site = subdomain)
      site
    else
      DEFAULT_SITES[I18n.locale.to_sym] # no symbol DoS because it's whitelisted
    end
  end

  def host
    request && request.host
  end

  def site_dir
    "#{sites_dir}/#{params[:site]}"
  end

  def sites_dir
    Site.sites_dir(I18n.locale)
  end

  def sites
    Dir["#{sites_dir}/*"].map { |path| path.split('/').last }
  end

  def redirect_sites
    {
      'curriculum' => 'intro-to-rails',
      'intermediate-rails' => 'message-board'
    }
  end

  before do
    begin
      I18n.locale = dynamic_locale
    rescue I18n::InvalidLocale
      I18n.locale = I18n.default_locale
    end
  end

  after '/:site/*' do
    # Any real page (starts with a site and doesn't end with an extension)
    # gets saved as the 'back' for the next pageload.
    if sites.include?(params[:site]) && !request.fullpath.match(/\..+\z/)
      cookies[:docs_back_path] = request.fullpath
    end
  end

  def dynamic_locale
    (params && (params[:locale] or params[:l])) or
      (host && AVAILABLE_LOCALES.include?(subdomain) && subdomain) or
      (ENV['SITE_LOCALE'])
  end

  def src
    File.read(doc_path)
  end

  def ext
    $1 if doc_path.match(/\.(.*)/)
  end

  def doc_path
    @doc_path ||= begin
      base = "#{site_dir}/#{params[:name]}"
      Site::DOC_TYPES.each do |ext|
        path = "#{base}.#{ext}"
        return path if File.exist?(path)
      end
      raise Errno::ENOENT, base
    end
  end

  def back_path
    path_parts = cookies[:docs_back_path].try(:split, '/')
    return unless path_parts && path_parts.length > 2

    current_path_parts = request.fullpath.split('/')
    prev_site, prev_page = path_parts[1..2]
    this_site, this_page = current_path_parts[1..2]

    return unless prev_site == this_site
    return if prev_page == this_page

    prev_page
  end

  def render_page
    begin
      options = {
        site_name: params[:site],
        page_name: params[:name],
        doc_title: Titleizer.title_for_page(params[:name]),
        doc_path: doc_path,
        back: back_path,
        src: src,
        locale: I18n.locale,
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

  get "/assets/:file.:ext" do
    mime_type = {
      'js' => 'application/javascript',
      'css' => 'text/css',
      'ttf' => 'application/font-ttf',
      'woff' => 'application/font-woff'
    }[params[:ext]]
    content_type mime_type if mime_type
    settings.assets["#{params[:file]}.#{params[:ext]}"]
  end

  get '/fonts/font-awesome/:file' do
    font_path = File.join(FontAwesome::Sass.gem_path, 'assets', 'fonts', 'font-awesome', params[:file])
    send_file font_path
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
        locale: I18n.locale,
      ).to_html
    rescue Errno::ENOENT => e
      p e
      halt 404
    end
  end

  get "/:site/:name.zip" do
    manifest_path = "#{site_dir}/#{params[:name]}.zip-manifest"
    if File.exists?(manifest_path)
      manifest_files = File.read(manifest_path).split("\n")
      zip_path = File.join(Dir.tmpdir, "#{params[:name]}.zip")
      FileUtils.rm_rf(zip_path)
      Zip::File.open(zip_path, Zip::File::CREATE) do |zipfile|
        manifest_files.each do |filename|
          zipfile.add(File.join(params[:name], File.basename(filename)), File.join(site_dir, filename))
        end
      end
      send_file zip_path
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

  get "/:site/:subdir/:name.:ext" do
    if sites.include?(params[:site])
      send_file "#{site_dir}/#{params[:subdir]}/#{params[:name]}.#{params[:ext]}"
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
    redirect request.fullpath.chomp('/')
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
