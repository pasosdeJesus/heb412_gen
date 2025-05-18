# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require "heb412_gen"

module Dummy
  class Application < Rails::Application
    config.load_defaults(Rails::VERSION::STRING.to_f)

    config.autoload_lib(ignore: ["assets", "tasks"])

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

    config.relative_url_root = ENV.fetch("RUTA_RELATIVA", "/heb412")

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
