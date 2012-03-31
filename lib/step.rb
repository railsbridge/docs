require 'erector'
require 'sass' # todo: move into erector

class Step < Erector::Widget
  include GithubFlavoredMarkdown

  def self.scss content
    here = File.dirname __FILE__
    Sass.compile("@import '#{here}/../public/css/bourbon/css3/_border-radius'; #{content}")
  end    
  
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
  
  # todo: extract into a module somehow
  external :style, scss(<<-CSS)
  $big_checkbox_size: 48px;
  
  input.big_checkbox[type=checkbox] {
    display:none;
    + label {
       height: $big_checkbox_size;
       width: $big_checkbox_size;
       display:inline-block;
       padding: 0 0 0 0px;
       margin: 0 4px -8px 0;
       background-color: white;
       z-index: 2;
       border: 4px solid #dadada;
       @include border-radius(10px);
    }
     
    + label:hover {
       background-image: url(/img/check-dim.png);
       cursor: pointer;
    }
  }
  
  input.big_checkbox[type=checkbox]:checked {
    + label {
      background-image: url(/img/check.png);
    }
  }
  CSS
  
  def big_checkbox
# check.png from http://findicons.com/icon/251632/check?id=396591
# technique thanks to http://nicolasgallagher.com/css-background-image-hacks/
# and http://stackoverflow.com/questions/3772273/pure-css-checkbox-image-replacement
# https://gist.github.com/592332 
    if @checkbox_number.nil?
      @checkbox_number = 0
    end
    @checkbox_number += 1
    input.big_checkbox type:"checkbox", name: "big_checkbox_#{@checkbox_number}", value:"valuable", id:"big_checkbox_#{@checkbox_number}"
    label for: "big_checkbox_#{@checkbox_number}"
  end

  def step name = nil, options = {}
    num = next_step_number
    a(:name => "step#{current_anchor_num}")
    div :class => "step", :title => name do
      h1 do
        big_checkbox
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

