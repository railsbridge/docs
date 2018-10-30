module StepExtensions
  module IntroToRails
    def model_diagram options
      header = options.delete(:header)
      fields = options.delete(:fields)
      table(options.merge(class: 'model-diagram')) do
        thead do
          tr do
            th header
          end
        end
        tbody do
          fields.each do |field|
            tr do
              td field
            end
          end
        end
      end
    end
  end
end