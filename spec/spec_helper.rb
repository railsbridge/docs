here = File.expand_path File.dirname(__FILE__)
top = File.expand_path "#{here}/.."
$: << "#{top}/lib"

require "rspec"
require "wrong/adapters/rspec"
require "nokogiri"

def assert_loosely_equal lhs, rhs
  assert { lhs.gsub(/\n\s*/, '') == rhs.gsub(/\n\s*/, '') }
end

require "files"
include Files   # todo: include this in an RSpec config block instead

