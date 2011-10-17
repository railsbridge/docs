require 'erector'

class Step < Erector::Widget
  include GithubFlavoredMarkdown

  external :style, <<-CSS
.step h1>span.prefix {
  color: blue;
}

.step blockquote {
  border-left: 1px dotted blue;
  padding-left: 1.5em;
  margin-left: .25em;
}
.step .todo span {
  background-color: #f5e1f0;
  font-style: italic;
  padding: .25em 1em;
}
.step .todo:before { }
.step .todo:after { }
  CSS

  def initialize options
    super
    @step_stack = []
  end

  def next_step
    @step_stack << 0 if @step_stack.empty?
    @step_stack[-1] = @step_stack.last + 1
  end

  def step name = nil
    if name.is_a? Symbol
      p :class => "linked_step" do
        text "Click here to learn how to "
        # todo: extract StepFile with unified naming routines
        step_title = name.to_s.split('_').map{|s| s.capitalize}.join(' ')
        a step_title, :href => name
      end
    else
      div :class => "step" do
        h1 do
          span "Step #{next_step}: ", :class => "prefix"
          text name
        end
        yield if block_given?
      end
    end
  end

  def choice name = "between..."
    step "Choose #{name}" do
      blockquote do
        @step_stack.push 0
        yield # if block_given?
        @step_stack.pop
      end
    end
  end

  def option name
    h1 do
      span "Option #{next_step}: "
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

  def note text
    p raw(md2html text)
  end

  def verify text = nil
    step "Verify #{text}" do
      blockquote do
        yield
      end
    end
  end

  def console msg
    p do
      text "Type this on the console:"
      pre msg
    end
  end

  def todo message
    div :class=>"todo" do
      span do
        text "[TODO: "
        text message
        text "]"
      end
    end
  end

  def result text
    p do
      text "Expected result:"
      pre text
    end
  end

  def content
    eval @src, binding, @doc_path, 1
  end
end

