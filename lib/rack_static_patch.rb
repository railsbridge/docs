# Fix Rack bug https://github.com/rack/rack/issues/301
module Rack
  class Static
    def initialize(app, options={})
      @app = app
      @urls = options[:urls] || ["/favicon.ico"]
      @index = options[:index]
      root = options[:root] || Dir.pwd
      cache_control = options[:cache_control]
      @file_server = Rack::File.new(root, cache_control)
    end
  end
end
