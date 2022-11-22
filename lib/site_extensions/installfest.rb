module StepExtensions
  module Installfest
    def version_string(name)
      case name
        when :ruby_short
          '2.3.8'
        when :windows_rubygems_min
          '2.6.7'
        when :windows_rubygems_min_short
          '2.6'
        else
          raise StandardError, "No version string exists for '#{name}'"
      end
    end
  end
end
