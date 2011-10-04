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
  
  def toc
    docs=Dir.glob("#{here}/doc/*").map{|file| file.split('.').first}
    md=docs.map do |path|
      title = path.split('/').last.capitalize
      path = path.gsub(/^#{here}/, '')
      "* [#{title}](#{path})"
    end.join("\n")
    md2html md
  end
  
  def mw2md md
    md.
      gsub(/^=== ?(.*)( *===)$/, '## \\1').
      gsub(/^== ?(.*)( *==)$/, '# \\1').
      gsub(/\[\[([^\]]*)\]\]/) {|match|
        match = $1
        if match =~ /^File:/i
          path = match.gsub(/^File:/i, '').strip
          "![#{path.split('/').last}](/doc/#{path})".tap{|img| d { img }}          
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
      gsub(/''(.+)''/, '*\\1*')
      # gsub(%r{(?<!\[)(https?|mailto)://\S*}, '<\\1>')
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
      
      erector {
        head {
          title params[:name].capitalize
        }
        body {
          div(:class=>:toc) {
            rawtext toc
          }
          div(:class=>:doc) {
            rawtext md2html(src)
          }
        }
      }
    rescue Errno::ENOENT => e
      p e
      halt 404
    end
  end
end

