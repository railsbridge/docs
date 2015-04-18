require 'erector'
require 'doc_page'
require 'step'

class StepPage < DocPage
  def doc_content
    widget Step.new src: src, doc_path: @doc_path
  end
end
