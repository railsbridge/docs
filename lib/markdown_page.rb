require 'erector'
require 'doc_page'
require 'markdown_renderer'

class MarkdownPage < DocPage
  def doc_content
    rawtext MarkdownRenderer.render(src)
  end
end
