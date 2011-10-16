here = File.expand_path File.dirname(__FILE__)
require "#{here}/spec_helper"

require "checklist_page"

describe ChecklistPage do

  it "renders a step file" do
    src = "step 'hello'"
    page = ChecklistPage.new(src: src,
      case_name: "greetings",
      doc_title: "Hello",
      doc_path: "/tmp/hello.step"
    )
    html_doc = Nokogiri.parse(page.to_html)
    main_html = html_doc.css(".main").first.serialize(:save_with => 0).chomp
    assert { main_html ==
      "<div class=\"main\">" +
        "<h1 class=\"doc_title\">Hello</h1>" +
        "<div class=\"doc\">" +
          "<div class=\"step\">" +
            "<h2><span class=\"prefix\">Step 1: </span>hello</h2>" +
          "</div>" +
        "</div>" +
      "</div>"
    }
  end

end

