require 'erector'
require 'big_checkbox'
require 'erector_scss'

class Step < Erector::Widget
  include GithubFlavoredMarkdown

  external :style, scss(<<-CSS)
.step {
  h1>span.prefix {
    color: blue;
  }

  blockquote {
    border-left: 1px dotted blue;
    padding-left: 1.5em;
    margin-left: .25em;
  }

}

.message img.icon {
  float: left;
  border: none;
  margin-right: 1em;
}

.message.todo {
  margin: 1em;
  background-color: #f5e1f0;
  font-style: italic;
  padding: .25em 1em;
  :before { }
  :after { }
}

.important, .tip {
  padding: .5em 1em;
  margin: 1em 0;
}

.important {
  border: 1px solid red;
}

.tip {
  border: 1px solid blue;
  padding: 1em;
}
.tip > span {
  font-size: 14pt;
}
.tip span.name {
  font-weight: bold;
}
.tip span.prefix {
  font-weight: bold;
  color: #E77902;
}

.step.next_step p.link:after {
  content: " \u2192";
}
div.back:before {
  content: "\u2190 ";
}

.steps {
}

.doc>div>h1 {
  padding-left: .25em;
}
.doc>div {
  padding-bottom: 1em;
}
.goals>h1 {
  background-color: #FECACD;
}
.steps>h1 {
  background-color: #FBFFCA;
}
.explanation>h1 {
  background-color: #C8FFC9;
}

.console > pre {
  border: 4px solid #dde;
  @include border-radius(4px);
  background-color: black;
  color: white;
}

.result > pre {
  border: 4px solid #dde;
  @include border-radius(4px);
}
  CSS

  needs :src
  needs :doc_path

  def initialize options
    super
    @step_stack = []
  end

  def next_step_number
    @step_stack << 0 if @step_stack.empty?
    @step_stack[-1] = @step_stack.last + 1
  end

  def as_title name
    name.to_s.split('_').map{|s| s.capitalize}.join(' ')
  end

  def prefix s
    span s, :class => "prefix"
  end

  def current_anchor_num
    nested_steps = @step_stack.dup
    nested_steps.pop if nested_steps.last == 0
    nested_steps.join("-")
  end

  # todo: move into proper Doc class
  def page_name
    @doc_path.split('/').last.split('.').first
  end

  ## steps

  def steps
    div :class => "steps" do
      h1 "Steps"
      blockquote do
        yield
      end
    end
  end

  def explanation
    div :class => "explanation" do
      h1 "Explanation"
      blockquote do
        yield
      end
    end
  end

  
  def step name = nil, options = {}
    num = next_step_number
    a(:name => "step#{current_anchor_num}")
    a(:name => options[:anchor_name]) if options[:anchor_name]
    div :class => "step", :title => name do
      h1 do
        widget BigCheckbox
        prefix "Step #{num}: "
        text name
      end
      if block_given?
        @step_stack.push 0
        blockquote do
          yield
        end
        @step_stack.pop
      end
    end
  end

  def link name
    p :class => "link" do
      text "Go on to "
      # todo: extract StepFile with unified name/title/path routines
      require 'uri'
      hash = URI.escape '#'
      href = name + "?back=#{page_name}#{hash}step#{current_anchor_num}"
      a as_title(name), :href => href, :class => 'link'
    end
  end

  def next_step name
    div :class => "step next_step" do
      h1 do
        prefix "Next Step:"
      end
      link name
    end
  end

  def choice name = "between..."
    step "Choose #{name}" do
      blockquote do
        @step_stack.push 0
        yield
        @step_stack.pop
      end
    end
  end

  def option name
    num = next_step_number
    a(:name => "step#{current_anchor_num}")  # todo: test
    h1 do
      span "Option #{num}: "
      text name
    end
    if block_given?
      blockquote do
        @step_stack.push 0
        yield # if block_given?
        @step_stack.pop
      end
    end

  end

  def section text
    div do
      h1 text
      blockquote do
        yield
      end
    end
  end

  def verify text = nil
    div :class=> "verify" do
      h1 "Verify #{text}"
      blockquote do
        yield
      end
    end
  end

  def goals
    div :class => "goals" do
      h1 "Goals"
      ul do
        yield
      end
    end
  end

  alias_method :goal, :li

  ## message

  def message text = nil, options = {}
    classes = (["message"] + [options[:class]]).compact
    div :class => classes do
      img.icon src: "/img/#{options[:icon]}.png" if options[:icon]
      rawtext(md2html text) unless text.nil?
      yield if block_given?
    end
  end

  def important text = nil, &block
    message text, class: "important", icon: "warning", &block
  end

  def tip text = nil, &block
    message text, class: "tip", icon: "info", &block
  end
  
  def todo todo_text
    message nil, class: "todo" do
      span do
        text "[TODO: "
        text todo_text
        text "]"
      end
    end
  end

  ## special
  
  TERMINAL_CAPTION = "Type this in the terminal:"
  RESULT_CAPTION = "Expected result:"
  
  def console msg
    div :class => "console" do
      span TERMINAL_CAPTION
      pre msg
    end
  end

  def result text
    div :class => "result" do
      span RESULT_CAPTION
      pre text
    end
  end

  def content
    eval @src, binding, @doc_path, 1
  end

  def source_code *args
    src = args.pop
    lang = args.pop
    src = "\n:::#{lang}\n#{src}" if lang
    pre src, :class => "code"
  end
end

