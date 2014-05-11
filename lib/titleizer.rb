module Titleizer
  def self.title_for_page page_name
    to_be_upcased = %w(
      argv
      crud
      css
      dvd
      html
      mvc
      rvm
      ssh
    )

    to_be_lowercased = %w(
      irb
      nil
      vs
    )

    special_cases = {
      'jquery' => 'jQuery',
      'osx' => 'OS X'
    }

    page_name.split(/[-_]/).map do |w|
      if to_be_upcased.include?(w.downcase)
        w.upcase
      elsif to_be_lowercased.include?(w.downcase)
        w.downcase
      elsif special_cases.include?(w)
        special_cases[w]
      else
        w.capitalize
      end
    end.join(' ')
  end
end
