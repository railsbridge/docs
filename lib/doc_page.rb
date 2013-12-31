require 'erector'
require "contents"
require "site_index"
require 'erector_scss'
require 'titleizer'
require 'docs_external_renderer'

class DocPage < Erector::Widgets::Page
  needs :site_name, :doc_title, :doc_path, :page_name, :src
  needs :back => nil
  attr_reader :site_name, :doc_title, :page_name, :src

  def self.css_path
    here = File.expand_path File.dirname(__FILE__)
    File.expand_path "#{here}/../public/css"
  end

  # wire up the DocsExternalRenderer
  def included_head_content
    included_widgets = [self.class] + output.widgets.to_a + extra_widgets
    DocsExternalRenderer.new(:classes => included_widgets).to_html
  end

  def doctype
    '<!doctype html>'
  end

  def html_attributes
    {:lang => 'en'}
  end

  def head_content
    title page_title
    script :src => "/jquery.min.js"
    script :src => "/js/bootstrap.min.js"
    script :src => "/js/doc_page.js"
    link   :href => "/font-awesome/css/font-awesome.min.css", :rel => "stylesheet"
  end

  def site_title
    "#{Titleizer.title_for_page(site_name)}"
  end

  def page_title
    "#{doc_title} - #{site_title}"
  end

  external :style, scss(File.read("#{css_path}/header.scss"))
  external :style, scss(File.read("#{css_path}/toc.scss"))
  external :style, scss(File.read("#{css_path}/doc_page.scss"))

  # this is how to load the Open Sans font when we know we're online
  # external :style,  <<-CSS
  # @import url(http://fonts.googleapis.com/css?family=Open+Sans:400italic,400,700);
  # CSS

  # but this is to load the Open Sans font when we might be offline
  external :style,  <<-CSS
  @import url(/fonts/opensans.css);
  @import url(/fonts/aleo.css);
  @import url(/css/coderay.css);
  CSS

  class TopLink < Erector::Widget
    needs :name, :href, :toggle_selector => nil, :extraclass => nil
    def content
      li(:class => @extraclass) {
        a "#{@name}", :href => @href,
          'data-toggle-selector' => @toggle_selector
      }
    end
  end

  # todo: test
  def file_name
    @doc_path.split('/').last
  end

  # todo: test
  def git_url
    "https://github.com/railsbridge/docs/blob/master/sites/#{@site_name}/#{file_name}"
  end

  def src_url
    "#{file_name.split('.').first}/src"
  end

  def top_links
    [
      TopLink.new(name: "toc", href: "#", extraclass: 'show-when-small', toggle_selector: '#table_of_contents'),
      TopLink.new(name: "src", href: src_url),
      TopLink.new(name: "git", href: git_url),
    ]
  end

  def body_attributes
    if site_name == 'docs'
      {class: 'no-toc'}
    else
      {}
    end
  end

  def body_content
    nav(class: "top cf", role: "navigation") {

      div(class: "navbar-header cf title") {
        a(href: "/#{site_name}") {
          span("RailsBridge ", class: "brand")
          text site_title
        }
      }
      ul(class: "navbar-nav nav") {

        li(class: "dropdown") {
          a("sites", href: "#", class: "dropdown-toggle", "data-toggle" => "dropdown")
          widget SiteIndex, site_name: site_title
        }

        top_links.each do |top_link|
          widget top_link
        end
      }
    }

    widget Contents, site_name: site_name, page_name: page_name

    div(class: :main) {
      h1 doc_title, class: "doc_title"
      div(class: :doc) {
        doc_content
      }
      if @back
        div.back {
          text "Back to "
          a(class: "back", href: @back) do
            text Titleizer.title_for_page(@back.split('#').first)
          end
        }
      end
    }

    div(class: 'bottom') {
      p "RailsBridge Docs is maintained by RailsBridge volunteers."
      p do
        text "If you find something that could be improved, please make a "
        a "pull request ", href: "https://github.com/railsbridge/docs"
        text "or "
        a "drop us a note ", href: "https://github.com/railsbridge/docs/issues/new"
        text "via GitHub Issues (no technical knowledge required)."
      end
      p do
        text "Source: "
        url "https://github.com/railsbridge/docs"
      end
    }
  end

end
