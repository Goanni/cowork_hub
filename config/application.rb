require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module CoworkHub
  class Application < Rails::Application
    config.load_defaults 8.1

    config.i18n.default_locale = :ru
    config.i18n.available_locales = [:ru, :en]
    
    config.time_zone = "Moscow"
    config.active_record.default_timezone = :local
  end
end