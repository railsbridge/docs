module StepExtensions
  module Installfest
    def version_string(name)
      case name
        when :ruby_short
          '2.3'
        when :windows_rubygems_min
          '2.6.7'
        when :windows_rubygems_current
          '2.6.8'
        else
          raise StandardError, "No version string exists for '#{name}'"
      end
    end
  end
end