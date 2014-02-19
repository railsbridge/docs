Encoding.default_external = Encoding::UTF_8

require 'coderay'
require 'rack/codehighlighter'
require 'i18n'
require 'i18n/backend/fallbacks'

use Rack::ShowExceptions
use Rack::ShowStatus
use Rack::Static, :urls => ["/css", "/img"], :root => "public"
use Rack::Codehighlighter, :coderay, :element => "pre.code", :pattern => /\A\s*:::(\w+)\s*\n/
use Rack::Codehighlighter, :coderay,
  :element => "pre>code",
  :markdown => true,
  :pattern => /\A[:@]{3}\s?(\w+)\s*(\n|&#x000A;)/i

# require 'thin/logging'
# Thin::Logging.debug = true
I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'config', 'locales', '*.yml').to_s]
I18n.backend.load_translations

require './app'
run Rack::Cascade.new([
  Deck::RackApp.public_file_server,
  InstallFest
  ])
