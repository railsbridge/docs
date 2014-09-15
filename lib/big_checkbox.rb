require 'erector_scss'

class BigCheckbox < Erector::Widget
  # for testing -- set the next number
  def self.number= checkbox_number
    @@checkbox_number = checkbox_number
  end

  def content
# check.png from http://findicons.com/icon/251632/check?id=396591
# technique thanks to http://nicolasgallagher.com/css-background-image-hacks/
# and http://stackoverflow.com/questions/3772273/pure-css-checkbox-image-replacement
# and https://gist.github.com/592332
    checkbox_number = (@@checkbox_number ||= 0)
    input.big_checkbox type: "checkbox", name: "big_checkbox_#{checkbox_number}", value: "valuable", id: "big_checkbox_#{checkbox_number}"
    label for: "big_checkbox_#{checkbox_number}"
    @@checkbox_number += 1
  end
end
