# frozen_string_literal: true

sidekiq_config = { url: ENV.fetch('JOB_WORKER_URL', nil) }

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end
