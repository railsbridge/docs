require 'erector'
require 'big_checkbox'
require 'erector_scss'
require 'markdown_renderer'

class Step < Erector::Widget
  external :style, <<-CSS
    @import url(/css/step.css);
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

  def insert file
    # todo: unify into common 'find & process a document file' unit
    dir = File.dirname(@doc_path)
    path = File.join(dir, "_#{file}.step")  # todo: other file types
    src = File.read(path)
    step = Step.new(src: src, doc_path: path)
    widget step
  end

  ## steps

  @@header_sections = {
    steps:"Steps",
    explanation:"Explanation",
    overview:"Overview",
    discussion:"Discussion Items",
    hints:"Hints",
    tools_and_references:"Tools and References",
    requirements:"Requirements to advance",
  }

  @@header_sections.each do |type, header|
    define_method type do |&block|
      div :class => type do
        h1 header
        blockquote do
          block.call if block
        end
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
        prefix "Step #{num}" + (!name.nil? ? ': ' : '')
        text name
      end
      _render_inner_content &Proc.new if block_given?
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

  def spanish_link name
    p :class => "link" do
      text "Ir a "
      # todo: extract StepFile with unified name/title/path routines
      require 'uri'
      hash = URI.escape '#'
      href = name + "?back=#{page_name}#{hash}step#{current_anchor_num}"
      a as_title(name), :href => href, :class => 'link'
    end
  end

  def link_without_toc name
    link name
  end

  def next_step name
    div :class => "step next_step" do
      h1 do
        prefix "Next Step:"
      end
      link name
    end
  end

  def siguiente_paso name
    div :class => "step next_step" do
      h1 do
        prefix "Siguiente Paso:"
      end
      spanish_link name
    end
  end

  def situation name
    h1 name
    _render_inner_content &Proc.new if block_given?
  end

  def choice name = "between..."
    step "Choose #{name}" do
      _render_inner_content &Proc.new if block_given?
    end
  end

  def option name
    num = next_step_number
    a(:name => "step#{current_anchor_num}")  # todo: test
    h1 do
      span "Option #{num}: "
      text name
    end
    _render_inner_content &Proc.new if block_given?
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
  IRB_CAPTION = "Type this in irb:"
  RESULT_CAPTION = "Expected result:"
  FUZZY_RESULT_CAPTION = "Approximate expected result:"

  def console(commands)
    console_with_message(TERMINAL_CAPTION, commands)
  end

  def console_with_message(message, commands)
    div :class => "console" do
      span message
      pre commands
    end
  end

  def console_without_message(commands)
    console_with_message("", commands)
  end

  def irb msg
    div :class => "console" do
      span IRB_CAPTION
      pre msg
    end
  end

  def type_in_file filename, msg
    div do
      span "Type this in the file #{filename}:"
      source_code :ruby, msg
    end
  end

  def further_reading
    div :class => "further-reading" do
      h1 "Further Reading"
      blockquote do
        yield
      end
    end
  end

  def result text
    div :class => "result" do
      span RESULT_CAPTION
      pre text
    end
  end

  def fuzzy_result fuzzed_text
    div :class => "result fuzzy-result" do
      span FUZZY_RESULT_CAPTION
      remaining_text = fuzzed_text
      pre do
        while match = remaining_text.match(/(.*?){FUZZY}(.*?){\/FUZZY}(.*)/m)
          text match[1]
          span match[2], :class => 'fuzzy-lightened'
          remaining_text = match[3]
        end
        text remaining_text
      end
      div "The greyed-out text may differ and is not important.", :class => 'fuzzy-hint'
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

  def md2html text
    MarkdownRenderer.render(text)
  end

  def model_diagram options
    header = options.delete(:header)
    fields = options.delete(:fields)
    table(options.merge(class: 'model-diagram')) do
      thead do
        tr do
          th header
        end
      end
      tbody do
        fields.each do |field|
          tr do
            td field
          end
        end
      end
    end
  end

  private

  def _render_inner_content
    blockquote do
      @step_stack.push 0
      yield
      @step_stack.pop
    end
  end
end
