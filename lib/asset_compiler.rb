require 'singleton'

class AssetCompiler
  include Singleton

  def file_scss(path)
    @compiled_files ||= {}
    @compiled_files[path] ||= begin
      Sass.compile(File.read(path))
    end
  end

  def font_awesome
    @font_awesome ||= begin
      scss_path = File.join(FontAwesome::Sass.gem_path, 'assets', 'stylesheets', 'font-awesome.scss')
      Sass.compile(<<-EOT)
        $fa-font-path: '/fonts/font-awesome/';
        #{File.read(scss_path)}
      EOT
    end
  end
end