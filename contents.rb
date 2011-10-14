class Contents < Erector::Widget
  needs :case_name
  
  def case_dir
    @case_dir ||= begin
      here = File.expand_path(File.dirname(__FILE__))
      "#{here}/cases/#{@case_name}"
    end
  end
    
  def docs ext = "mw,md"
    Dir.glob("#{case_dir}/*.{#{ext}}").map{|file| file.split('.').first}
  end
    
  def content
    div class: "toc" do
      h1 "Contents"
      docs.each do |path|
        title = path.split('/').last.capitalize
        path = path.gsub(/^#{case_dir}\//, '')
        li { a(title, :href => path) }
      end

      h1 "Images"
      Dir.glob("#{case_dir}/*.{jpg,png}").each do |path|
        title = path.split('/').last.capitalize
        path = path.gsub(/^#{case_dir}\//, '')
        li { a(title, :href => path) }
      end
    end
  end
end  
