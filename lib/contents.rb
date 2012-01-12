
class Contents < Erector::Widget
  needs :site_name

  def site_dir
    @site_dir ||= begin
      here = File.expand_path File.dirname(__FILE__)
      top = File.expand_path "#{here}/.."
      "#{top}/sites/#{@site_name}"
    end
  end

  def site_files ext
    Dir.glob("#{site_dir}/*.{#{ext}}").sort
  end

  def docs ext = "mw,md,step"
    site_files(ext).map{|file| file.split('.').first}.uniq
  end

  def content
    div class: "toc" do
      h1 "Contents"
      docs.each do |path|
        title = path.split('/').last.split('_').map{|s|s.capitalize}.join(' ')
        path = path.gsub(/^#{site_dir}\//, "/#{@site_name}/")
        li { a(title, :href => path) }
      end

      h1 "Images"
      site_files("jpg,png").each do |path|
        title = path.split('/').last
        path = path.gsub(/^#{site_dir}\//, '')
        li { a(title, :href => path) }
      end
    end
  end
end
