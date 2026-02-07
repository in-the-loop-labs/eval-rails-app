# SPDX-License-Identifier: MIT
# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 3.2"

# Core
gem "rails", "~> 7.1.0"
gem "pg", "~> 1.5"
gem "puma", "~> 6.4"

# Assets & Views
gem "sprockets-rails"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder", "~> 2.11"

# Authentication & Authorization
gem "devise", "~> 4.9"
gem "pundit", "~> 2.3"

# Background Jobs
gem "sidekiq", "~> 7.2"

# Performance
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "rspec-rails", "~> 6.1"
  gem "factory_bot_rails", "~> 6.4"
  gem "faker", "~> 3.2"
end

group :development do
  gem "web-console"
  gem "rubocop-rails", "~> 2.23", require: false
  gem "rubocop-rspec", "~> 2.25", require: false
end

group :test do
  gem "shoulda-matchers", "~> 6.0"
  gem "capybara"
  gem "selenium-webdriver"
end
