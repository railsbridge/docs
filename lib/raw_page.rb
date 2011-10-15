require 'erector'
require 'doc_page'

class RawPage < DocPage

  def show_src?
    false
  end

  def doc_content
    pre src
  end
end
