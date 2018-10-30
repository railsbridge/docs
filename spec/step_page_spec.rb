require "spec_helper"
require "site"
require "step_page"

describe StepPage do
  before do
    setup_test_translations
  end

  # functional test -- brittle
  it "renders a step file" do
    BigCheckbox.number = 1

    src = "step 'hello'"
    page = StepPage.new(
      src: src,
      site: Site.new("greetings"),
      page_name: 'hello',
      doc_title: "Hello",
      doc_path: "/tmp/hello.step",
      locale: "en"
    )

    html_doc = Nokogiri.parse(page.to_html)
    main_html = html_doc.css("main").first.serialize(:save_with => 0).chomp
    checkbox_html = %q{<input class="big_checkbox" id="big_checkbox_1" name="big_checkbox_1" type="checkbox" value="valuable"><label for="big_checkbox_1"></label>}

    expect(main_html).to loosely_equal(<<-HTML.strip_heredoc)
      <main>
        <h1 class="doc_title">Hello</h1>
        <div class="doc">
          <a name="step1"></a>
          <div class="step">
            <h1>#{checkbox_html}<span class="prefix">Step 1: </span>hello</h1>
          </div>
        </div>
      </main>
    HTML
  end

end

