require 'erector'
require "github_flavored_markdown"
require "contents"

# class Doc
#   def initialize path_from_sites
#     parts = @path_from_sites.split('/')
#     @site_name = parts.shift
#     @file_name = parts.last
#     @file_type = @file_name.split('.').last
#     @base_name = @file_name.split('.').first
# end

class DocPage < Erector::Widgets::Page
  include GithubFlavoredMarkdown

  needs :site_name, :doc_title, :doc_path
  needs :back => nil
  attr_reader :site_name, :doc_title

  needs :src
  attr_reader :src

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

  .toc {
    background: #e2f2f2;
    padding: 1em;
    margin: 0 0 1em 1em;
    float: right;
    width: 18em;
    overflow-x: hidden;
    display: none;
  }

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
      TopLink.new(:name => "toc", :href => "#", :onclick => "$('div.toc').toggle();"),
      TopLink.new(:name => "git", :href => "https://github.com/railsbridge/installfest/blob/master/sites/#{@site_name}/#{file_name}"),
    ]
  end

  def head_content
    super
    script :src => "/jquery-1.6.1.js"
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
