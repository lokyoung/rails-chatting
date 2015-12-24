require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RealtimeChatting
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    LetterAvatar.setup do |config|
      config.cache_base_path = 'public/system/lets' # default is 'public/system'
      config.colors_palette = :iwanthue             # default is :google
    end

    # use sidekiq as the activejob adapter
    config.active_job.queue_adapter = :sidekiq
  end
end
