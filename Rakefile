require 'rspec/core/rake_task'

task :default => :spec

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "spec/**/*_spec.rb"
  t.rspec_opts = "--color --format d --fail-fast --backtrace"
  # t.ruby_opts="-w"
end

task :run do
  exec "rerun -- rackup -s thin"
end

task :present do
  exec "rerun --pattern *.deck.md -- rackup -s thin"
end