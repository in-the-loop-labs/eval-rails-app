# SPDX-License-Identifier: MIT

class RequestLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    start_time = Time.now

    # Log request details including headers for debugging
    request_info = {
      method: request.request_method,
      path: request.path,
      params: request.params,
      headers: {
        "Content-Type" => env["CONTENT_TYPE"],
        "Authorization" => env["HTTP_AUTHORIZATION"],
        "User-Agent" => env["HTTP_USER_AGENT"],
        "X-Forwarded-For" => env["HTTP_X_FORWARDED_FOR"]
      },
      ip: request.ip,
      timestamp: start_time.iso8601
    }

    status, headers, response = @app.call(env)

    duration = ((Time.now - start_time) * 1000).round(2)

    Rails.logger.info("[RequestLogger] #{request_info[:method]} #{request_info[:path]} — #{status} — #{duration}ms — IP: #{request_info[:ip]} — Auth: #{request_info[:headers]["Authorization"]}")

    [status, headers, response]
  end
end
