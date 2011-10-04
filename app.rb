# http://daringfireball.net/projects/markdown/syntax#img
# http://www.wiki.devchix.com/index.php?title=Help:Editing

require 'sinatra'
require 'digest/md5'
require 'erector'
require 'wrong'
include Wrong::D

begin
  require 'rdiscount'
rescue LoadError
  require 'bluecloth'
  Object.send(:remove_const,:Markdown)
  Markdown = BlueCloth
end

class InstallFest < Sinatra::Application
  include Erector::Mixin
  
  def initialize
    super
    @here = File.expand_path(File.dirname(__FILE__))
  end
  
  attr_reader :here

  # From http://github.github.com/github-flavored-markdown/
  def gfm(text)
    # Extract pre blocks
    extractions = {}
    text.gsub!(%r{<pre>.*?</pre>}m) do |match|
      md5 = Digest::MD5.hexdigest(match)
      extractions[md5] = match
      "{gfm-extraction-#{md5}}"
    end

    # prevent foo_bar_baz from ending up with an italic word in the middle
    text.gsub!(/(^(?! {4}|\t)\w+_\w+_\w[\w_]*)/) do |x|
      x.gsub('_', '\_') if x.split('').sort.to_s[0..1] == '__'
    end

    # in very clear cases, let newlines become <br /> tags
    text.gsub!(/^[\w\<][^\n]*\n+/) do |x|
      x =~ /\n{2}/ ? x : (x.strip!; x << "  \n")
    end

    # Insert pre block extractions
    text.gsub!(/\{gfm-extraction-([0-9a-f]{32})\}/) do
      "\n\n" + extractions[$1]
    end

    text
  end

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
  
  def mw2md md
    md.
      # headings
      gsub(/^==== ?(.*)( *====)\s*$/, '### \\1').
      gsub(/^=== ?(.*)( *===)\s*$/, '## \\1').
      gsub(/^== ?(.*)( *==)\s*$/, '# \\1').
      gsub(/^= ?(.*)( *=)\s*$/, '# \\1').
      # bullet lists
      gsub(/^\* /, "\n* ").
      gsub(/^\*\* /, " * ").
      gsub(/^\*\*\* /, "  * ").
      # numbered lists
      gsub(/^\# /, "\n1. ").
      gsub(/^\#\# /, " 1. ").
      gsub(/^\#\#\# /, "  1. ").
      # links
      gsub(%r{(?<![\(:])((https?|mailto)://\S*)}, '<\\1>').
      
      gsub(/\[\[([^\]]*)\]\]/) {|match|
        match = $1
        if match =~ /^File:/i
          path = match.gsub(/^File:/i, '').strip
          url = if path =~ /^http/
            path
          else 
            "/doc/#{path}"
          end
          "![#{path.split('/').last}](#{url})".tap{|img| d { img }}          
        else
          title = match.gsub(/[\(\)]/, '')
          page = title.downcase.gsub(/\W/, '')
          d { title }
          d { page }
          s="[#{title}](#{page})"
          d { s }
          s
        end
      }.      
      gsub(/(?<!\!)\[([^\] ]*)( [^\]]*)?\]/){
        url = $1
        name = $2 || url
        "[#{name}](#{url})"
      }.
      gsub(/'''(.+)'''/, '**\\1**').
      gsub(/''(.+)''/, '*\\1*').
      # tables
      gsub(/^\{\|(.*)$/) {"<table #{$1}>\n<tr>\n"}.
      gsub(/^\|-/, "<tr>").
      gsub(/^\|\+(.*)/, "<tr><th>\\1<tr>").
      gsub(/^\! /, "<th>").
      gsub(/^\| /, "<td>").
      gsub(/^\|\}/, "</table>")
  end
  
  def md2html(md)
    Markdown.new(gfm(md)).to_html
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
    d { params[:name] }
    send_file "#{here}/doc/#{params[:name]}.#{params[:ext]}"
  end
  
  get "/doc/:name" do
    begin
      d { src }
      doc_title = params[:name].split('_').map do |w| 
        w == "osx" ? "OS X" : w.capitalize
      end.join(' ')
      d { params[:name] }
      d { doc_title }
      erector {
        head {
          title doc_title
          style <<-CSS
          body {
            font-family: futura,helvetica,arial,sans;
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

