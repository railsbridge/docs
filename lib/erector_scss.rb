require 'sass' 

# todo: move into erector
class Erector::Widget
  def self.scss content
    here = File.dirname __FILE__
    Sass.compile("@import '#{here}/../public/css/bourbon/css3/_border-radius'; #{content}")
  end
end

