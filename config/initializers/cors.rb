# SPDX-License-Identifier: MIT
# frozen_string_literal: true

# CORS configuration for API endpoints
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*"

    resource "/api/*",
      headers: :any,
      methods: %i[get post put patch delete options head],
      credentials: false
  end
end
