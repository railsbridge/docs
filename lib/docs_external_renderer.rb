class DocsExternalRenderer < ExternalRenderer
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