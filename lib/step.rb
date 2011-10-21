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

.step .important, .step .tip {
  padding: .5em 1em;
  margin: 1em 0;
}

.step .important {
  border: 1px solid red;
}
.step .tip {
  border: 1px solid blue;
}
.step .tip span.name {
  font-weight: bold;
}
.step .tip span.prefix {
  font-weight: bold;
  color: blue;
}

  CSS

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

  ## steps

  def step name = nil
    div :class => "step" do
      h1 do
        prefix "Step #{next_step_number}: "
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
      a as_title(name), :href => name
    end
  end

  def next_step name
    div :class => "step next" do
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
    h1 do
      span "Option #{next_step_number}: "
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

  def verify text = nil
    div :class=> "verify" do
      h1 "Verify #{text}"
      blockquote do
        yield
      end
    end
  end

  ## notes

  def note text
    p raw(md2html text)
  end
  
  def important text = nil
    div :class=>"important" do
      rawtext(md2html text) unless text.nil?
      yield if block_given?
    end
  end

  def tip name = nil
    div :class=>"tip" do
      span "Tip: ", :class => "prefix"
      span name, :class=>"name" if name
      yield if block_given?
    end
  end


  def console msg
    div :class => "console" do
      text "Type this in the terminal:"
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
    div :class => "step" do
      eval @src, binding, @doc_path, 1
    end
  end
end

