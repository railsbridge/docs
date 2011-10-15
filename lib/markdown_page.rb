require 'erector'
require 'doc_page'

class MarkdownPage < DocPage
  def doc_content
    rawtext md2html(src)
  end
end
