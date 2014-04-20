
# Flag icons borrowed from https://www.gosquared.com/resources/flag-icons/
# Put them in public/flags
class Flags < Erector::Widget

  def initialize *args
    super
    @locales = ["us", "es"]
  end

  def content
    ul.flags do
      @locales.each do |locale|
        subdomain = (locale == "us" ? "docs" : locale)
        li {
          a(href:"http://#{subdomain}.railsbridge.org") {
            img src: "/railsbridge/images/flags/#{locale.upcase}.png"
          }
        }
      end
    end
  end
end
