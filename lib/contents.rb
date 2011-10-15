
class Contents < Erector::Widget
  needs :case_name

  def case_dir
    @case_dir ||= begin
      here = File.expand_path File.dirname(__FILE__)
      top = File.expand_path "#{here}/.."
      "#{top}/cases/#{@case_name}"
    end
  end

  def case_files ext
    Dir.glob("#{case_dir}/*.{#{ext}}").sort
  end

  def docs ext = "mw,md,checklist"
    case_files(ext).map{|file| file.split('.').first}
  end

  def content
    div class: "toc" do
      h1 "Contents"
      docs.each do |path|
        title = path.split('/').last.split('_').map{|s|s.capitalize}.join(' ')
        path = path.gsub(/^#{case_dir}\//, '')
        li { a(title, :href => path) }
      end

      h1 "Images"
      case_files("jpg,png").each do |path|
        title = path.split('/').last.capitalize
        path = path.gsub(/^#{case_dir}\//, '')
        li { a(title, :href => path) }
      end
    end
  end
end
