# SPDX-License-Identifier: MIT
# frozen_string_literal: true

# Assuming you have not yet modified this file, each configuration option below
# is set to its default value. Note that some are commented out while others
# are not: uncommented lines are intended to protect your configuration from
# breaking changes in upgrades (i.e., in the event that a default is changed).
#
# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
Devise.setup do |config|
  # The secret key used by Devise. Devise uses this key to generate random
  # tokens. Changing this key will render invalid all existing confirmation,
  # reset password and unlock tokens in the database.
  # config.secret_key = Rails.application.credentials.secret_key_base

  # ==> Controller configuration
  # Configure the parent class to the devise controllers.
  # config.parent_controller = "ActionController::Base"

  # ==> Mailer Configuration
  config.mailer_sender = "noreply@taskflow.example.com"

  # ==> ORM configuration
  require "devise/orm/active_record"

  # ==> Configuration for any authentication mechanism
  # Configure which keys are used when authenticating a user.
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]

  # ==> Configuration for :database_authenticatable
  config.stretches = Rails.env.test? ? 1 : 12

  # ==> Configuration for :confirmable
  # config.allow_unconfirmed_access_for = 2.days

  # ==> Configuration for :rememberable
  config.remember_for = 2.weeks

  # ==> Configuration for :validatable
  config.password_length = 8..128

  # ==> Configuration for :lockable
  # config.lock_strategy = :failed_attempts
  # config.unlock_keys = [:email]
  # config.unlock_strategy = :both
  # config.maximum_attempts = 20
  # config.unlock_in = 1.hour

  # ==> Configuration for :recoverable
  config.reset_password_within = 6.hours

  # ==> Navigation configuration
  config.sign_out_via = :delete

  # ==> Responders configuration
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end
