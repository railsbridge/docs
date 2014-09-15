
# Flag icons borrowed from https://www.gosquared.com/resources/flag-icons/
# Put them in public/flags
class Flags < Erector::Widget
  needs :locale

  def initialize *args
    super
    @locales = ["en", "es", "zh-tw"]
  end

  def image_for_locale(locale)
    image_name = {"en" => "us"}[locale.to_s] || locale
    "/flags/#{image_name.upcase}.png"
  end

  def subdomain_for_locale(locale)
    {"en" => "docs"}[locale.to_s] || locale
  end

  def content
    li class: 'dropdown' do
      a class: 'dropdown-toggle', 'data-toggle' => 'dropdown'  do
        img src: image_for_locale(@locale)
      end
      ul class: 'flags dropdown-menu' do
        @locales.each do |locale|
          li {
            a(href:"http://#{subdomain_for_locale(locale)}.railsbridge.org") {
              img src: image_for_locale(locale)
            }
          }
        end
      end
    end
  end
end
