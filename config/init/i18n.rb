I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)

Dir[File.join(App.root, 'config', 'locales', '*.yml')].each do |file|
  I18n.backend.load_translations(file)
end
