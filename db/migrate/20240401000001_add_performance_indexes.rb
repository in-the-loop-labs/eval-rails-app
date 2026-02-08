# SPDX-License-Identifier: MIT
# frozen_string_literal: true

class AddPerformanceIndexes < ActiveRecord::Migration[7.1]
  def change
    # Add composite indexes for common query patterns
    add_index :tasks, %i[project_id status]
    add_index :notifications, %i[recipient_id read]

    # Note: comments.user_id and tasks.user_id are foreign keys
    # but are not indexed here — consider adding them for
    # better join performance on larger datasets.
  end
end
