require 'erector'
require "contents"
require "site_index"

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
  needs :site_name, :doc_title, :doc_path, :page_name
  needs :back => nil
  attr_reader :site_name, :doc_title, :page_name

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
    script :src => "/jquery-1.7.2.min.js"
    script :src => "/js/bootstrap.min.js"
    script :src => "/js/doc_page.js"
  end

  def site_title
    "#{site_name.split(/[-_]/).map(&:capitalize).join(" ")}"
  end

  def page_title
    "#{doc_title} - #{site_title}"
  end

  external :style,  <<-CSS
  @import url(/css/bootstrap.min.css);
  CSS

  # this is how to load the Open Sans font when we know we're online
  # external :style,  <<-CSS
  # @import url(http://fonts.googleapis.com/css?family=Open+Sans:400italic,400,700);
  # CSS

  # but this is to load the Open Sans font when we might be offline
  external :style,  <<-CSS
  @import url(/fonts/opensans.css);
  CSS

  # Load the header font.
  external :style,  <<-CSS
  @import url(/fonts/aleo.css);
  CSS

  external :style,  <<-CSS
  @import url(/css/coderay.css);
  CSS

  external :style,  <<-CSS
  @import url(/css/doc_page.css);
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

  def body_content
    div(:class => "top navbar navbar-default", :role => "navigation") {
      div(:class => "navbar-header title") {
        a(:href => "/#{site_name}") {
          span("RailsBridge ", :class => "brand") 
          text site_name.capitalize
        }
      }
      div(:class => "collapse navbar-collapse") {
        ul(:class => "navbar-nav nav navbar-right") {

          li(:class => "dropdown") {
            a("sites", :href => "#", :class => "dropdown-toggle",
              "data-toggle" => "dropdown")
            widget SiteIndex, site_name: site_name
          }

          top_links.each do |top_link|
            widget top_link
          end

        }
      }
    }

    widget Contents, site_name: site_name, page_name: page_name

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

    div(class: 'bottom') {
      p "RailsBridge Docs"
      p do
        text "Source: "
        url "https://github.com/railsbridge/docs"
      end
    }
  end

end
