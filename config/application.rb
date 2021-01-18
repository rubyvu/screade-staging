require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ScreadeRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    
    # Load ENV variables
    Figaro.load
    
    # Disable automatic generation for TestUnit, JS, CSS files and helpers
    config.generators do |g|
      g.test_framework  :rspec, views: false, fixture: true
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
      g.template_engine :slim
      g.stylesheets false
      g.javascripts false
      g.helper false
    end
  end
end
