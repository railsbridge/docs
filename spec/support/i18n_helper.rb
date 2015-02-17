require 'i18n'

module I18nHelper
  def setup_test_translations
    here = File.expand_path File.dirname(__FILE__)
    top = File.expand_path "#{here}/../.."

    I18n::Backend::Simple.include(I18n::Backend::Fallbacks)
    I18n.load_path = Dir[File.join(top, 'locales', '*.yml')]
    I18n.backend.load_translations

    I18n.available_locales = Dir['sites/*'].map { |path| File.basename(path).to_sym }
    I18n.locale = :en
  end
end