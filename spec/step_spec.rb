here = File.expand_path File.dirname(__FILE__)
require "#{here}/spec_helper"

require "step_page"

describe Step do

  it "renders a step file" do
    src = "step 'hello'"
    page = Step.new(src: src,
      case_name: "greetings",
      doc_title: "Hello",
      doc_path: "/tmp/hello.step"
    )
    html_doc = Nokogiri.parse(page.to_html)
    html = html_doc.css(".step").first.serialize(:save_with => 0).chomp
    assert { html ==
          "<div class=\"step\">" +
            "<h1><span class=\"prefix\">Step 1: </span>hello</h1>" +
      "</div>"
    }
  end

end

