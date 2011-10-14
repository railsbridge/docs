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
require "./github_flavored_markdown"

class InstallFest < Sinatra::Application
  include Erector::Mixin
  include MediaWiki
  include GithubFlavoredMarkdown
  
  def initialize
    super
    @here = File.expand_path(File.dirname(__FILE__))
  end
  
  attr_reader :here

  def src
    File.read("#{here}/doc/#{params[:name]}.md")
  rescue Errno::ENOENT
    mw2md File.read("#{@here}/doc/#{params[:name]}.mw")
  end

  def docs ext = "mw,md"
    Dir.glob("#{here}/doc/*.{#{ext}}").map{|file| file.split('.').first}
  end
  
  def toc
    md = ""
    md << "# Contents\n"    
    md << docs.map do |path|
      title = path.split('/').last.capitalize
      path = path.gsub(/^#{here}/, '')
      "* [#{title}](#{path})"
    end.join("\n")

    md << "\n\n# Images\n"
    md << Dir.glob("#{here}/doc/*.{jpg,png}").map do |path|
      title = path.split('/').last.capitalize
      path = path.gsub(/^#{here}/, '')
      "* [#{title}](#{path})"
    end.join("\n")

    md2html md
  end
  
  def md2html(md)
    Markdown.new(gfm(md)).to_html
  end

  get "/" do
    redirect "/doc/topics"
  end

  get "/doc/:name/src" do
    begin
      "<pre>#{source}</pre>"
    rescue Errno::ENOENT => e
      p e
      halt 404
    end
  end
  
  get "/doc/:name.:ext" do
    send_file "#{here}/doc/#{params[:name]}.#{params[:ext]}"
  end
  
  get "/doc/:name" do
    begin
      doc_title = params[:name].split('_').map do |w| 
        w == "osx" ? "OS X" : w.capitalize
      end.join(' ')
      erector {
        head {
          title doc_title
          style <<-CSS
          body {
            font-family: helvetica,arial,sans;
          }
          h1 {
            font-size: 2em;
            -webkit-margin-before: 0;
            -webkit-margin-after: 0;
            -webkit-margin-start: 0;
            -webkit-margin-end: 0;            
          }

          .top {
            margin-bottom: 1em;
          }
          .toc {
            background: #e2f2f2;
            padding: 1em;
            margin: 0 1em;
            float: left;
            width: 18em;
          }
          .main {
            padding-left: 24em;
          }
          .doc { 
            max-width: 50em;
          }
          .main h1.doc_title {
            background: #e2e2f2;
            padding: .5em;
            margin-bottom: .25em;
            margin-left: -2em;
          }          
          .doc pre {
            background: #f2f2f2;
            padding: .5em 1em;
            font-size: 12pt;
          }
          CSS
        }
        body {
          div(:class=>:top) {
            h1 "Railsbridge Installfest and Workshop"
          }
          div(:class=>:toc) {
            rawtext toc
          }
          div(:class=>:main) {
            h1 doc_title, :class=>"doc_title"
            div(:class=>:doc) {
              rawtext md2html(src)
            }
          }
          
        }
      }
    rescue Errno::ENOENT => e
      p e
      halt 404
    end
  end
end

