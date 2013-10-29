module Titleizer
  def self.title_for_page page_name
    abbrevs = {
      'osx' => 'OS X',
      'rvm' => 'RVM',
      'ssh' => 'SSH',
      'dvd' => 'DVD',
      'irb' => 'irb'
    }

    page_name.split(/[-_]/).map do |w|
      abbrevs.keys.include?(w) ? abbrevs[w] : w.capitalize
    end.join(' ')
  end
end