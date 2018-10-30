module MediaWiki
  def mw2md md
    md.
    # bullet lists
    gsub(/^\* /, "\n* ").
    gsub(/^\*\* /, " * ").
    gsub(/^\*\*\* /, "  * ").

    # square-bullet lists (turn into regular bullets)
    gsub(/^# /, "\n* ").
    gsub(/^## /, " * ").
    gsub(/^### /, "  * ").

    # headings
    gsub(/^==== ?(.*)( *====)\s*$/, "### \\1").
    gsub(/^=== ?(.*)( *===)\s*$/, "## \\1").
    gsub(/^== ?(.*)( *==)\s*$/, "# \\1").
    gsub(/^= ?(.*)( *=)\s*$/, "# \\1").

    # plain links
    gsub(%r{(?<![\(:])((https?|mailto)://\S*)}, '<\\1>').

    # # [name url] links
    # gsub(/(?<!\!\[)\[([^\] ]*)( [^\]]*)?\]/){
    #   url = $1
    #   name = $2 || url
    #   "[#{name}](#{url})"
    # }.

    # [[]] links
    gsub(/\[\[([^\]]*)\]\]/) {|match|
      match = $1
      if match =~ /^File:/i
        path = match.gsub(/^File:/i, '').strip
        url = if path =~ /^http/
          path
        else
          "#{path}"
        end
        "![#{path.split('/').last}](#{url})"
      else
        title = match.gsub(/[\(\)]/, '')
        page = title.downcase.gsub(/\W+/, '_').strip
        "[#{title}](#{page})"
      end
    }.
    gsub(/'''(.+)'''/, '**\\1**').
    gsub(/''(.+)''/, '*\\1*').
    # tables
    gsub(/^\{\|(.*)$/) {"<table #{$1}>\n<tr>\n"}.
    gsub(/^\|-/, "<tr>").
    gsub(/^\|\+(.*)/, "<tr><th>\\1<tr>").
    gsub(/^! /, "<th>").
    gsub(/^\| /, "<td>").
    gsub(/^\|\}/, "</table>")
  end
end
