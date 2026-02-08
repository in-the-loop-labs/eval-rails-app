# SPDX-License-Identifier: MIT
# frozen_string_literal: true

module Searchable
  extend ActiveSupport::Concern

  class_methods do
    def searchable_fields(*fields)
      @searchable_fields = fields

      scope :search, ->(query) {
        return all if query.blank?

        conditions = fields.map { |f| arel_table[f].matches("%#{sanitize_sql_like(query)}%") }
        where(conditions.reduce(:or))
      }
    end

    def searchable_field_list
      @searchable_fields || []
    end
  end
end
