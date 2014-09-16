require 'sass'

class Erector::Widget
  def self.scss content
    Sass.compile(content)
  end
end

