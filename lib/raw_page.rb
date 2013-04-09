require 'erector'
require 'doc_page'

class RawPage < DocPage
  def src_url
    "../#{file_name.split('.').first}"
  end

  def show_src?
    false
  end

  def doc_content
    pre src
  end
end
