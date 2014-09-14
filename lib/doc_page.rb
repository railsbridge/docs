require 'erector'
require "contents"
require "site_index"
require 'erector_scss'
require 'titleizer'
require 'html5_page'
require 'flags'
require 'erb'

class DocPage < Html5Page
  needs :site_name, :doc_title, :doc_path, :page_name, :src, :locale
  needs :back => nil
  attr_reader :site_name, :doc_title, :page_name, :src

  def self.css_path
    here = File.expand_path File.dirname(__FILE__)
    File.expand_path "#{here}/../public/css"
  end

  def head_content
    title page_title
    script :src => "/jquery.min.js"
    script :src => "/js/bootstrap.min.js"
    script :src => "/js/doc_page.js"
    link   :href => "/font-awesome.css", :rel => "stylesheet"
  end

  def site_title
    Titleizer.title_for_page(site_name)
  end

  def page_title
    "#{doc_title} - #{site_title}"
  end

  external :style, file_scss("#{css_path}/header.scss")
  external :style, file_scss("#{css_path}/toc.scss")
  external :style, file_scss("#{css_path}/doc_page.scss")

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

  def file_name
    @doc_path.split('/').last
  end

  def git_url
    "https://github.com/railsbridge/docs/blob/master/sites/#{@locale}/#{@site_name}/#{file_name}"
  end

  def src_url
    "#{file_name.split('.').first}/src"
  end

  def top_links
    [
      TopLink.new(name: "toc", href: "#", extraclass: 'show-when-small', toggle_selector: '#table_of_contents'),
      TopLink.new(name: "src", href: src_url, extraclass: 'hidden-sm'),
      TopLink.new(name: "git", href: git_url, extraclass: 'hidden-sm'),
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
        widget Flags, locale: @locale

        li(class: "dropdown") {
          a("sites", href: "#", class: "dropdown-toggle", "data-toggle" => "dropdown")
          widget SiteIndex, site_name: site_name, locale: @locale
        }

        top_links.each do |top_link|
          widget top_link
        end
      }
    }

    widget Contents, locale: @locale, site_name: site_name, page_name: page_name

    main {
      before_title
      h1 doc_title, class: "doc_title"
      div(class: :doc) {
        doc_content
      }
      if @back
        # Encode page name and fragment name separately so that
        # the fragment indicator '#' won't be escaped.
        page_name, fragment = @back.split('#')
        url_components = [ERB::Util.u(page_name)]
        url_components << ERB::Util.u(fragment) if fragment
        back_url = url_components.join('#')

        div.back {
          text I18n.t("general.back_to") + " "
          a(class: "back", href: back_url) do
            text Titleizer.title_for_page(page_name)
          end
        }
      end
    }

    footer {
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

  def before_title
    # placeholder for subclass override
  end

end
