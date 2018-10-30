class Html5ExternalRenderer < ExternalRenderer
  # render <style> tags plainly, without "text/css" (which browsers will assume by default)
  #   or the xml:space attribute (not allowed or required in html5)
  def inline_styles
    rendered_externals(:style).each do |external|
      style(external.options) { rawtext external.text }
    end

    if Object.const_defined?(:Sass)
      rendered_externals(:scss).each do |external|
        style(external.options) { rawtext Sass.compile(external.text) }
      end
    end
  end
end

class Html5Page < Erector::Widgets::Page
  tag 'main'

  def doctype
    '<!doctype html>'
  end

  def html_attributes
    {:lang => 'en'}
  end

  # wire up the Html5ExternalRenderer
  def included_head_content
    included_widgets = [self.class] + output.widgets.to_a + extra_widgets
    Html5ExternalRenderer.new(:classes => included_widgets).to_html
  end
end