# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require "heb412_gen"

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults(7.0)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "America/Bogota"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :es

    config.railties_order = [
      :main_app,
      Heb412Gen::Engine,
      Mr519Gen::Engine,
      Msip::Engine,
      :all,
    ]

    config.active_record.schema_format = :sql

    config.x.formato_fecha = ENV.fetch("MSIP_FORMATO_FECHA", "yyyy-mm-dd")

    config.x.heb412_ruta = Pathname(ENV.fetch(
      "HEB412_RUTA", Rails.public_path.join("heb412").to_s
    ))

    puts "CONFIG_HOSTS=" + ENV.fetch("CONFIG_HOSTS", "defensor.info").to_s
    config.hosts.concat(
      ENV.fetch("CONFIG_HOSTS", "defensor.info").downcase.split(";"),
    )

    # config.web_console.whitelisted_ips = '190.27.122.155'
  end
end
