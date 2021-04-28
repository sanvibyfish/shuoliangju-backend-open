require_relative "boot"
require File.expand_path("../boot", __FILE__)
ENV["RANSACK_FORM_BUILDER"] = "::SimpleForm::FormBuilder"
require "rails/all"
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Railtie.load


module ShuoliangjuBackend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.active_record.default_timezone = :local
    config.time_zone = ENV["timezone"] || "Beijing"

    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]
    # add lib modules
    config.paths.add Rails.root.join("lib").to_s, eager_load: true
    config.i18n.default_locale = "zh-CN"
    config.generators do |g|
      g.template_engine :slim
      g.factory_bot true
    end

    config.to_prepare do
      ActiveStorage::Blob.send :include, ::ActiveStorageBlobExtension
    end
    

    #activestoage attached
    config.active_storage.replace_on_assign_to_many = false

    config.active_job.queue_adapter = :sidekiq

    config.action_mailer.default_url_options = { :host => "shuoliangju.cn" }

    config.action_mailer.delivery_method = :smtp

    config.action_mailer.raise_delivery_errors = true

    config.action_mailer.smtp_settings = {
      address: "smtp.exmail.qq.com",
      port: 465,
      domain: "qq.com",
      user_name: "noreply@shuoliangju.cn",
      password: "fajpAsK8gUSWeTDe",
      authentication: :login,
      ssl: true
      # enable_starttls_auto: true
    }

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins "*"
        resource "*", headers: :any, methods: [:get, :post, :options]
      end
    end

    redis_config = Application.config_for(:redis)
    config.cache_store = [:redis_cache_store, { namespace: "cache", url: redis_config["url"], expires_in: 2.weeks }]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
