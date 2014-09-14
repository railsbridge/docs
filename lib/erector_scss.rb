require 'sass'
require_relative 'asset_compiler'

class Erector::Widget
  def self.scss content
    Sass.compile(content)
  end

  def self.file_scss path
    AssetCompiler.instance.file_scss(path)
  end
end

