require 'erector'
require 'doc_page'
require 'redcarpet'
require 'coderay'

class HTMLwithCodeRay < Redcarpet::Render::HTML
  def block_code(code, language)
    if language
      "<pre class='CodeRay'>#{CodeRay.scan(code, language).html}</pre>"
    else
      "<pre class='CodeRay'>#{CodeRay.scan(code, :text).html}</pre>"
    end
  end
end

MarkdownRenderer = Redcarpet::Markdown.new(
    HTMLwithCodeRay,
    :autolink => true,
    :space_after_headers => true,
    :fenced_code_blocks => true
)

class MarkdownPage < DocPage
  def doc_content
    rawtext MarkdownRenderer.render(src)
  end
end
