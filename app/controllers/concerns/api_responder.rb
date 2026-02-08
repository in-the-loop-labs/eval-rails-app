# SPDX-License-Identifier: MIT
# frozen_string_literal: true

module ApiResponder
  extend ActiveSupport::Concern

  included do
    skip_before_action :verify_authenticity_token
  end

  private

  def render_success(data, status: :ok)
    render json: data, status: status
  end

  def render_created(data)
    render json: data, status: :created
  end

  def render_errors(record)
    render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
  end

  def render_not_found
    render json: { error: "Not found" }, status: :not_found
  end
end
