require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "rails/test_unit/railtie"
require "action_mailer/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LogisticsSystem
  class Application < Rails::Application
    config.load_defaults 6.0
    config.api_only = true
  end
end
