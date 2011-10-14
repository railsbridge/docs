require 'erector'
require "./github_flavored_markdown"


class MarkdownPage < Erector::Widget
  include GithubFlavoredMarkdown
  
  def md2html(md)
    Markdown.new(gfm(md)).to_html
  end
  
  needs :case_name, :doc_title, :markdown_src
  attr_reader :case_name, :doc_title, :markdown_src
  
  def case_title
    "Railsbridge #{case_name.capitalize}"
  end
  
  def content
    head {
      title "#{doc_title} - #{case_title}"
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
      .top a {
        text-decoration: none;
      }
      .top a:visited {
        color: black;
      }

      .bottom {
        min-height: 60px;
        
      }

      .toc {
        background: #e2f2f2;
        padding: 1em;
        margin: 0 1em;
        float: left;
        width: 18em;
        overflow-x: hidden;
      }

      .main {
        padding-left: 24em;
      }
      .main h1.doc_title {
        background: #e2e2f2;
        padding: .5em;
        margin-bottom: .25em;
        margin-left: -2em;
      }          
      
      .doc { 
        max-width: 50em;
      }
      .doc pre {
        background: #f2f2f2;
        padding: .5em 1em;
        font-size: 12pt;
      }
      .doc h1 {
        border-bottom: 1px solid blue;
        margin-top: 1em;
        margin-left: -.5em;
      }
      CSS
    }
    body {
      div(:class=>:top) {
        h1 { a case_title, :href => "/#{case_name}" }
      }

      widget Contents, case_name: case_name

      div(:class=>:main) {
        h1 doc_title, :class=>"doc_title"
        div(:class=>:doc) {
          rawtext md2html(markdown_src)
        }
      }
      
      div(:class=>:bottom) {
        
      }
      
    }
  end
end
