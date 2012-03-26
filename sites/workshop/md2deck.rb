require "fileutils"

Dir["**/*.deck.md"].each do |file|
  parts = file.split(".")
  puts "* [#{parts.first.capitalize}](#{parts.first})"
end
