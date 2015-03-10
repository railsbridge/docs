require 'spec_helper'
require "site"
require "step_page"

describe Step do
  before do
    setup_test_translations
  end

  def to_html nokogiri_node
    nokogiri_node.serialize(:save_with => 0).chomp
  end

  def html_doc(src = "step 'hello'; step 'goodbye'")
    @html_doc ||= begin
      step = Step.new(src: src,
        doc_path: "/tmp/hello.step"
      )
      @html = step.to_html
      Nokogiri.parse("<html>#{@html}</html>")
    end
  end

  def step_obj_for(path)
    Step.new(src: File.read(path), doc_path: path)
  end

  it "renders a step file" do
    BigCheckbox.number = 1
    steps = html_doc.css(".step")
    html = to_html(steps.first)
    checkbox_html = %q{<input class="big_checkbox" id="big_checkbox_1" name="big_checkbox_1" type="checkbox" value="valuable"><label for="big_checkbox_1"></label>}
    expected = <<-HTML.strip_heredoc.gsub("\n", '')
      <div class="step">
      <h1>#{checkbox_html}<span class="prefix">Step 1: </span>hello</h1>
      </div>
    HTML
    assert { html == expected }
  end

  it "puts anchors in based on step numbers" do
    steps = html_doc.css(".step")
    steps.each_with_index do |step, i|
      assert { step.previous }
      assert { to_html(step.previous) == "<a name=\"step#{i+1}\"></a>" }
    end
  end

  it "puts anchors in based on optional step name" do
    html_doc(<<-RUBY)
      step "Test", {:anchor_name => 'happy_step'}
    RUBY

    anchors = html_doc.css("a")
    names = anchors.map{|a| a["name"]}
    assert { names == %w(step1 happy_step) }
  end

  it "nests anchor numbers" do
    html_doc(<<-RUBY)
      step "breakfast" do
        step "cereal"
        step "eggs"
      end
      step "lunch" do
        step "salad"
        step "sandwich"
      end
    RUBY

    anchors = html_doc.css("a")
    names = anchors.map{|a| a["name"]}
    assert { names == %w(step1 step1-1 step1-2 step2 step2-1 step2-2) }
  end

  describe 'link' do
    it "creates a link" do
      html_doc(<<-RUBY)
        step "breakfast" do
          link "choose_breakfast"
        end
        step "lunch" do
          step "salad"
          step "sandwich"
        end
      RUBY
      a = html_doc.css(".step a.link").first
      assert { a["href"] == "choose_breakfast" }
    end

    it "has an optional parameter for the caption" do
      html_doc(<<-RUBY)
      step "breakfast" do
        link "breakfast", caption: "Eat some"
      end
      RUBY
      assert { html_doc.css("p.link").text == "Eat some Breakfast" }
    end
  end

  describe 'source_code' do
    it "emits a block of code as a pre with class 'code'" do
      html_doc(<<-RUBY)
        source_code "x = 2"
      RUBY
      assert { @html == "<pre class=\"code\">x = 2</pre>" }
    end

    it "emits a block of code with a language directive" do
      html_doc(<<-RUBY)
        source_code :ruby, "x = 2"
      RUBY
      assert { @html == "<pre class=\"code\">\n:::ruby\nx = 2</pre>" }
    end
  end

  describe 'console' do
    it "emits a 'console' div with a 'pre' block" do
      html_doc(<<-RUBY)
        console "echo hi"
      RUBY
      assert_loosely_equal(@html, <<-HTML.strip_heredoc)
        <div class="console">
          <span>#{I18n.t('captions.terminal')}</span>
          <pre>echo hi</pre>
        </div>
      HTML
    end
  end

  describe 'result' do
    it "emits a 'result' div with a 'pre' block" do
      html_doc(<<-RUBY)
      result "hi"
      RUBY

      assert_loosely_equal(@html, <<-HTML.strip_heredoc)
        <div class="result">
          <span>#{I18n.t("captions.result")}</span>
          <pre>hi</pre>
        </div>
      HTML
    end
  end

  describe 'fuzzy_result' do
    it "emits a 'result' div with a 'pre' block where certain content is greyed out" do
      html_doc(<<-RUBY)
      fuzzy_result "hello {FUZZY}fuzz{/FUZZY} face! nice {FUZZY}banana{/FUZZY}\ni am more text!"
      RUBY

      assert_loosely_equal(@html, <<-HTML.strip_heredoc)
        <div class="result fuzzy-result">
          <span>#{I18n.t("captions.fuzzy_result")}</span>
          <pre>
            hello <span class="fuzzy-lightened">fuzz</span> face! nice <span class="fuzzy-lightened">banana</span>
            i am more text!
          </pre>
          <div class="fuzzy-hint">The greyed-out text may differ and is not important.</div>
        </div>
      HTML
    end
  end

  describe 'insert' do
    it 'renders a stepfile inside another stepfile' do
      path = dir 'testing-insert' do
        file "outer.step", <<-RUBY.strip_heredoc
          div 'hello'
          insert 'inner'
          insert 'inner'
          div 'goodbye'
        RUBY
        file "_inner.step", <<-RUBY.strip_heredoc
          div 'yum'
        RUBY
      end

      outer_path = File.join(path, 'outer.step')
      html = step_obj_for(outer_path).to_html

      assert_loosely_equal html, <<-HTML.strip_heredoc
        <div>hello</div>
        <div>yum</div>
        <div>yum</div>
        <div>goodbye</div>
      HTML
    end
  end
end
