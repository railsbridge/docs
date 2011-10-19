require 'markdown_page'
require 'media_wiki'

class MediaWikiPage < MarkdownPage
  include MediaWiki

  def initialize options
    options[:src] = mw2md(options[:src])
    super
  end
end
