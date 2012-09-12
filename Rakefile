require 'rspec/core/rake_task'

task :default => :spec

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "spec/**/*_spec.rb"
  t.rspec_opts = "--color --format d --fail-fast --backtrace"
  # t.ruby_opts="-w"
end

def rerun cmd, rerun_opts = nil
  if Rake::Win32.windows?
    exec cmd
  else
    exec "rerun #{rerun_opts} -- #{cmd}"
  end

end

desc "run the site locally (visit http://localhost:9292)"
task :run do
  rerun "rackup -s thin"
end
