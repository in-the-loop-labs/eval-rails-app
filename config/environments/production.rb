# SPDX-License-Identifier: MIT
# frozen_string_literal: true

require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.enable_reloading = false

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  config.eager_load = true

  # Full error reports are disabled since this is a production environment.
  config.consider_all_requests_local = false

  config.action_controller.perform_caching = true

  config.log_level = :debug

  # Ensures that a master key has been made available in ENV["RAILS_MASTER_KEY"],
  # config/master.key, or an environment variable.
  # config.require_master_key = true

  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  config.active_storage.service = :local

  # Force all access to the app over SSL, use Strict-Transport-Security,
  # and use secure cookies.
  config.force_ssl = true

  # Log tags for request tracking
  config.log_tags = [:request_id]
  config.log_formatter = ::Logger::Formatter.new

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Devise mailer configuration
  config.action_mailer.default_url_options = { host: ENV.fetch("APP_HOST", "taskflow.example.com") }
  config.action_mailer.raise_delivery_errors = true
end
