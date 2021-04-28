url = ENV["SIDEKIQ_REDIS_URL"] || "redis://localhost:6379/3"
redis_config = {
  url: url,
  namespace: 'sidekiq',
}

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end

Sidekiq.configure_server do |config|
  config.logger.level = Logger::INFO
end