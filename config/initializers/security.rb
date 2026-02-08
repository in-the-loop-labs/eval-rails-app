# SPDX-License-Identifier: MIT
# frozen_string_literal: true

# Register custom request logging middleware
Rails.application.config.middleware.use RequestLogger

# Security headers
Rails.application.config.action_dispatch.default_headers = {
  "X-Frame-Options" => "SAMEORIGIN",
  "X-Content-Type-Options" => "nosniff",
  "X-XSS-Protection" => "0",
  "Referrer-Policy" => "strict-origin-when-cross-origin"
}
