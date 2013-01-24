require 'erector_scss'

class BigCheckbox < Erector::Widget
  # needs :size => "48px"  # todo
    
  external :style, scss(<<-CSS)
  $big_checkbox_size: 20px;
  
  input.big_checkbox[type=checkbox] {
    display:none;
    + label {
       height: $big_checkbox_size;
       width: $big_checkbox_size;
       display:inline-block;
       padding: 2px;
       margin: 0 12px -8px 0;
       background-color: white;
       z-index: 2;
       border: 2px solid #dadada;
    }
     
    + label:hover {
       background-image: url(/img/check-dim.png);
       background-size: cover;
       cursor: pointer;
    }
  }
  
  input.big_checkbox[type=checkbox]:checked {
    + label {
      background-image: url(/img/check.png);
      background-size: cover;
    }
  }
  CSS
  
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
    input.big_checkbox type:"checkbox", name: "big_checkbox_#{checkbox_number}", value:"valuable", id:"big_checkbox_#{checkbox_number}"
    label for: "big_checkbox_#{checkbox_number}"
    @@checkbox_number += 1
  end
end
