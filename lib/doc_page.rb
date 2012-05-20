require 'erector'
require "github_flavored_markdown"
require "contents"

class InstallfestExternalRenderer < ExternalRenderer
  # render <style> tags plainly, without "text/css" (which browsers will assume by default)
  #   or the xml:space attribute (not allowed or required in html5)
  def inline_styles
    rendered_externals(:style).each do |external|
      style(external.options) { rawtext external.text }
    end

    if Object.const_defined?(:Sass)
      rendered_externals(:scss).each do |external|
        style(external.options) { rawtext Sass.compile(external.text) }
      end
    end
  end  
end

class DocPage < Erector::Widgets::Page
  include GithubFlavoredMarkdown

  needs :site_name, :doc_title, :doc_path
  needs :back => nil
  attr_reader :site_name, :doc_title

  needs :src
  attr_reader :src

  # wire up the InstallfestExternalRenderer
  def included_head_content
    included_widgets = [self.class] + output.widgets.to_a + extra_widgets
    InstallfestExternalRenderer.new(:classes => included_widgets).to_html
  end

  def doctype
    '<!doctype html>'
  end

  def html_attributes
    {:lang => 'en'}
  end

  def head_content
    title page_title
    script :src => "/jquery-1.6.1.js"
  end

  def site_title
    "Railsbridge #{site_name.capitalize}"
  end

  def page_title
    "#{doc_title} - #{site_title}"
  end


  # this is how to load the Open Sans font when we know we're online
  # external :style,  <<-CSS
  # @import url(http://fonts.googleapis.com/css?family=Open+Sans:400italic,400,700);
  # CSS

  # but this is to load the Open Sans font when we might be offline
  external :style,  <<-CSS
  @import url(/font/opensans.css);
  CSS

  external :style,  <<-CSS
  @import url(/css/coderay.css);
  CSS

  external :style,  <<-CSS
  body {
    font-family: 'Open Sans',helvetica,arial,sans-serif;
    padding: 0;
    margin: 0;
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
    padding: 2px 6px;
  }
  .top h1 {
    font-size: 2.5em;
    font-weight: 800;
  }
  .top a {
    text-decoration: none;
  }
  .top a:visited {
    color: black;
  }

  .bottom {
    min-height: 60px;
    text-align: center;
    border-top: 1px solid #333;
  }

  /* toc = Table of Contents */

  .toc {
    background: #e2f2f2;
    padding: 0 0 1em 0;
    margin: 0 0 1em 1em;
    border: 1px solid blue;
    float: right;
    width: 26em;
    overflow-x: hidden;
    display: none;
    /* if the toc isn't "positioned", images will show on top of it */
    position: relative;
  }
  
  .toc h1 {
    border-bottom: 1px solid blue;
    padding-left: 12px;
  }
  
  .toc ul {
    margin-left: 12px;
    padding-left: 12px;
  }
  
  .toc li a {
    font-size: 11pt;
    padding: 1px 2px;
    border: 1px solid #e2f2f2;
    text-decoration: none;
    display: block; /* fill the entire containing li */
  }

  .toc li a:hover {
    background: #a2aBFD;
    border-color: blue;
    cursor: pointer;
    font-weight: bold;
  }

  /**/

  .main {
    padding-left: 4em;
  }
  .main h1.doc_title {
    background: #e2e2f2;
    padding: .5em .5em .25em;
    margin-bottom: .25em;
    margin-left: -2em;
  }

  .doc {
    max-width: 50em;
  }

  .doc pre {
    background: #f2f2f2;
    padding: .5em 1em;
    font-size: 13pt;
    overflow-x: auto;
  }
  .doc code {
    font-size: 13pt;
    background: #f2f2f2;
    padding-left: 4px;
    padding-right: 4px;
  }
  .doc h1 {
    border-bottom: 1px solid blue;
    margin-top: 1em;
    margin-left: -.5em;
  }

  .top .top_links {
    float: right;
    margin-right: 8px;
  }
  .top a.top_link {
    float: right;
    margin: 2px;
  }

  img {
    border: 1px solid #aaa;
    margin: auto;
    display: block;  /* otherwise centering doesn't happen */
  }

  CSS

  class TopLink < Erector::Widget
    needs :name, :href, :onclick => nil
    def content
      a "[#{@name}]", :class => "top_link", :href => @href, :onclick => @onclick
    end
  end

  def top_links
    file_name = @doc_path.split('/').last
    [
      TopLink.new(:name => "src", :href => "#{file_name.split('.').first}/src"),
      TopLink.new(:name => "toc", :href => "#", :onclick => "$('div.toc').toggle(); return false;"),
      TopLink.new(:name => "git", :href => "https://github.com/railsbridge/installfest/blob/master/sites/#{@site_name}/#{file_name}"),
    ]
  end

  def body_content
    div.top {
      div.top_links {
        top_links.each do |top_link|
          widget top_link
        end
      }
      h1 { a site_title, :href => "/#{site_name}" }
    }

    widget Contents, site_name: site_name

    div(:class=>:main) {
      h1 doc_title, :class=>"doc_title"
      div(:class=>:doc) {
        doc_content
      }
      if @back
        div.back {
          text "Back to "
          a(:class => "back", :href => @back) do
            text @back.split('#').first #todo: titleize etc, use real doc object
          end
        }
      end
    }

    div(:class=>:bottom) {
      p "Railsbridge InstallFest"
      p do
        text "Source: "
        url "https://github.com/railsbridge/installfest"
      end
    }
  end

end
