module Titleizer
  def self.title_for_page page_name
    to_be_upcased = [
      'php',
      'rvm',
      'ssh',
      'dvd',
      'crud',
      'mvc',
      'html',
    ]

    special_cases = {
      'osx' => 'OS X',
      'irb' => 'irb',
      'docs' => 'Get Started',
    }

    page_name.split(/[-_]/).map do |w|
      if to_be_upcased.include?(w.downcase)
        w.upcase
      elsif special_cases.include?(w)
        special_cases[w]
      else
        w.capitalize
      end
    end.join(' ')
  end
end
