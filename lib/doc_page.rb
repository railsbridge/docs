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

  def head_content
    title page_title
    script :src => "/assets/application.js"
    link   :href => "/assets/application.css", :rel => "stylesheet"
  end

  def site_title
    Titleizer.title_for_page(site_name)
  end

  def page_title
    "#{doc_title} - #{site_title}"
  end

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
      p do
        text "Going through this curriculum on your own? Get help at "
        a "Code Newbie", href: "http://discourse.codenewbie.org/t/railsbridge-curriculum-questions/594/4"
        text ", where RailsBridge volunteers can answer your questions."
      end
      p do
        text "If you have a suggestion for improving the docs, please make a "
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
