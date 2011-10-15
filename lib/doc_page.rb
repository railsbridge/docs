require 'erector'
require "github_flavored_markdown"
require "contents"

# class Doc
#   def initialize path_from_cases
#     parts = @path_from_cases.split('/')
#     @case_name = parts.shift
#     @file_name = parts.last
#     @file_type = @file_name.split('.').last
#     @base_name = @file_name.split('.').first
# end

class DocPage < Erector::Widgets::Page
  include GithubFlavoredMarkdown

  needs :case_name, :doc_title, :doc_path
  attr_reader :case_name, :doc_title

  needs :src
  attr_reader :src

  def case_title
    "Railsbridge #{case_name.capitalize}"
  end

  def page_title
    "#{doc_title} - #{case_title}"
  end

  external :style,  <<-CSS
  @import url(http://fonts.googleapis.com/css?family=Open+Sans:400italic,400,700);
  body {
    font-family: 'Open Sans', helvetica,arial,sans-serif;
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

  }

  .toc {
    background: #e2f2f2;
    padding: 1em;
    margin: 0 0 1em 1em;
    float: right;
    width: 18em;
    overflow-x: hidden;
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
    font-size: 12pt;
    overflow-x: auto;
  }
  .doc h1 {
    border-bottom: 1px solid blue;
    margin-top: 1em;
    margin-left: -.5em;
  }

  .doc blockquote {
    border-left: 1px dotted blue;
    padding-left: 1em;
    margin-left: .25em;
  }
  .top a.src {
    float: right;
  }
  CSS

  def src_link
    a "[src]", :class=> "src", :href => "#{@doc_path.split('/').last.split('.').first}/src"
  end

  def show_src?
    true
  end

  def body_content
    div(:class=>:top) {
      src_link if show_src?
      h1 { a case_title, :href => "/#{case_name}" }
    }

    widget Contents, case_name: case_name

    div(:class=>:main) {
      h1 doc_title, :class=>"doc_title"


      div(:class=>:doc) {
        doc_content
      }
    }

    div(:class=>:bottom) {

    }
  end

end
