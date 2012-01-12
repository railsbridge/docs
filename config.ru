require 'rack/codehighlighter'
require 'coderay'

# Fix Rack bug https://github.com/rack/rack/issues/301
require './lib/rack_static_patch'

use Rack::ShowExceptions
use Rack::ShowStatus
use Rack::Static, :urls => ["/css", "/img"], :root => "public"
use Rack::Codehighlighter, :coderay, :element => "pre.code", :pattern => /\A\s*:::(\w+)\s*\n/

# require 'thin/logging'
# Thin::Logging.debug = true

require './app'
run InstallFest
