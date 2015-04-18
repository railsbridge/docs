module StepExtensions
  module JavascriptSnakeGame
    def js_expected_results(lesson)
      h3 'Expected Results'

      h4 'What your snake.js file should look like:'

      src_path = File.join(File.dirname(@doc_path), 'js', "#{lesson}.js")

      source_code :js, File.read(src_path)

      h4 'How the game should work:'

      canvas id: 'chunk-game', height: '600', width: '800'

      script src: 'js/chunk.js'

      script src: "js/#{lesson}.js"
    end
  end
end