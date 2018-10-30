require "spec_helper"
require "site"
require "markdown_page"

describe MarkdownPage do
  before do
    setup_test_translations
  end

  it "renders markdown into html" do
    src = <<-MARKDOWN.strip_heredoc
      # This is a heading

      ## This is a subheading
          <h2>This text is preformatted and escaped</h2>

      ```html
      This text is preformatted and ready to be <strong>syntax highlighted</strong> as HTML source.
      ```
    MARKDOWN

    page = MarkdownPage.new(
      src: src,
      site: Site.new("greetings"),
      page_name: 'hello',
      doc_title: "Hello",
      doc_path: "/tmp/hello.step",
      locale: "en"
    )

    html_doc = Nokogiri.parse(page.to_html)
    main_html = html_doc.css("main").first.serialize(:save_with => 0).chomp

    expect(main_html).to loosely_equal(<<-HTML.strip_heredoc)
      <main>
        <a href="hello.step.deck" style="float: right">Slides</a>
        <h1 class="doc_title">Hello</h1>
        <div class="doc">
          <h1>This is a heading</h1>
          <h2>This is a subheading</h2>
          <pre class="CodeRay">&lt;h2&gt;This text is preformatted and escaped&lt;/h2&gt;</pre>
          <pre class="CodeRay">This text is preformatted and ready to be <span class="tag">&lt;strong&gt;</span>syntax highlighted<span class="tag">&lt;/strong&gt;</span> as HTML source.</pre>
        </div>
      </main>
    HTML
  end
end

