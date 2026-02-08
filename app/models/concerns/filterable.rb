# SPDX-License-Identifier: MIT
# frozen_string_literal: true

module Filterable
  extend ActiveSupport::Concern

  class_methods do
    def filter_by(params)
      results = all

      params.each do |key, value|
        next if value.blank?

        results = results.public_send("by_#{key}", value) if respond_to?("by_#{key}")
      end

      results
    end
  end
end
