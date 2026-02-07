# SPDX-License-Identifier: MIT
# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  # Enums
  enum status: { active: 0, archived: 1, completed: 2 }

  # Validations
  validates :name, presence: true, length: { maximum: 255 }
  validates :name, uniqueness: { scope: :user_id, case_sensitive: false }
  validates :status, presence: true

  # Scopes
  scope :active, -> { where(status: :active) }
  scope :archived, -> { where(status: :archived) }
  scope :by_user, ->(user) { where(user: user) }
  scope :recently_updated, -> { order(updated_at: :desc) }
  scope :search_by_name, ->(query) { where("name ILIKE ?", "%#{query}%") }

  def owned_by?(user)
    user_id == user.id
  end
end
