# SPDX-License-Identifier: MIT
# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates :body, presence: true, length: { maximum: 10_000 }

  scope :recent, -> { order(created_at: :desc) }
  scope :oldest_first, -> { order(created_at: :asc) }
end
