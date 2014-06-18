def windows?
  Rake::Win32.windows?
end

begin
  require 'rspec/core/rake_task'

  task :default => :spec

  desc "Run all specs"
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = "spec/**/*_spec.rb"
    t.rspec_opts =
        "--format d"
    t.rspec_opts += " --color" unless windows?
    # t.ruby_opts="-w"
  end
rescue LoadError # swallow Heroku deploy error
end

def rerun cmd, rerun_opts = nil
  if windows?
    exec cmd
  else
    exec "rerun #{rerun_opts} -- #{cmd}"
  end
end

desc "run the site locally (visit http://localhost:9292)"
task :run do
  rerun "rackup -s thin -p #{ENV['PORT'] || 9292}"
end
