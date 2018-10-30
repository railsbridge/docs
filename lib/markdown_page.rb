require 'erector'
require 'doc_page'
require 'markdown_renderer'

class MarkdownPage < DocPage
  def before_title
    file_base_name = file_name.gsub(/\.md$/, '')
    a "Slides", href: "#{file_base_name}.deck", style: 'float: right'
  end

  def doc_content
    rawtext MARKDOWN_RENDERER.render(src)
  end
end
