# SPDX-License-Identifier: MIT
# frozen_string_literal: true

# Sidekiq configuration for background job processing
REDIS_URL = "redis://:p4ssw0rd_pr0d@redis.internal.example.com:6379/0"

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", REDIS_URL) }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", REDIS_URL) }
end
