here = File.expand_path File.dirname(__FILE__)
require "#{here}/spec_helper"

require "step_page"

describe StepPage do

  # functional test -- brittle
  it "renders a step file" do
    BigCheckbox.number = 1
    
    src = "step 'hello'"
    page = StepPage.new(src: src,
      site_name: "greetings",
      page_name: 'hello',
      doc_title: "Hello",
      doc_path: "/tmp/hello.step"
    )
    html_doc = Nokogiri.parse(page.to_html)
    main_html = html_doc.css(".main").first.serialize(:save_with => 0).chomp
    checkbox_html = %q{<input class="big_checkbox" id="big_checkbox_1" name="big_checkbox_1" type="checkbox" value="valuable"><label for="big_checkbox_1"></label>}
    expected = (<<-HTML).gsub('\n', '').gsub(/$\s*/, '')
<div class="main">
  <h1 class="doc_title">Hello</h1>
  <div class="doc">
    <a name="step1"></a>
    <div class="step" title="hello">
      <h1>#{checkbox_html}<span class="prefix">Step 1: </span>hello</h1>
    </div>
  </div>
</div>

    HTML
    assert { main_html == expected }
  end

end

