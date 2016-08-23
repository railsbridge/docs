module StepExtensions
  module Installfest
    def version_string(name)
      case name
        when :minimum_ruby
          '2.2.2'
        when :osx_ruby_short
          '2.3'
        when :windows_ruby_short
          '2.2'
        else
          raise StandardError, "No version string exists for '#{name}'"
      end
    end
  end
end