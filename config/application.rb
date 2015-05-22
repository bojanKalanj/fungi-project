require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FungiorbisPureRails
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = 'Belgrade'

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.available_locales = [:'sr-Latn', :sr, :en]
    # config.i18n.default_locale = :'sr-Latn'
    config.i18n.default_locale = :sr

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
  end
end

module I18n
  # exception, locale, key, options
  def self.transliterate_cyrillic(*args)
    if args[1] == :'sr-Latn'
      Fungiorbis::CyrToLat.transliterate(I18n.translate!(args[2], args[3].merge(locale: :sr)))
    end
  end
end
I18n.exception_handler = :transliterate_cyrillic