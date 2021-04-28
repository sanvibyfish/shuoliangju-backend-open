# frozen_string_literal: true
require 'connection_pool'

require "redis"
require "redis-namespace"
require "redis/objects"

redis_config = Rails.application.config_for(:redis)
$redis = Redis.new(url: redis_config["url"], driver: :hiredis)
sidekiq_url = redis_config["url"]
Redis::Objects.redis =ConnectionPool.new(size: 5, timeout: 5) { $redis }
