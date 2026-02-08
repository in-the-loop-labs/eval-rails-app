# SPDX-License-Identifier: MIT
# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user, optional: true

  # Enums
  enum status: { pending: 0, in_progress: 1, completed: 2, cancelled: 3 }
  enum priority: { low: 0, medium: 1, high: 2, urgent: 3 }

  has_many :notifications, dependent: :destroy

  # Validations
  validates :title, presence: true
  validates :status, presence: true
  validates :priority, presence: true
  validates :description, length: { maximum: 5000 }, allow_blank: true

  # Scopes
  scope :by_status, ->(status) { where(status: status) }
  scope :by_priority, ->(priority) { where(priority: priority) }
  scope :overdue, -> { where("due_date < ?", Date.current).where.not(status: :completed) }
  scope :due_soon, -> { where(due_date: Date.current..3.days.from_now) }
  scope :unassigned, -> { where(user_id: nil) }
  scope :assigned_to, ->(user) { where(user: user) }
  scope :recently_created, -> { order(created_at: :desc) }
  scope :search, ->(query) {
    where("title ILIKE :q OR description ILIKE :q", q: "%#{query}%")
  }
  scope :by_status_text, ->(status_text) {
    where("status::text = ?", status_text)
  }

  # Callbacks
  after_save :enqueue_notification

  private

  def enqueue_notification
    if saved_change_to_user_id? && user_id.present?
      TaskNotificationJob.perform_later(id, "assigned", project.user_id)
    end

    if saved_change_to_status?
      TaskNotificationJob.perform_later(id, "status_changed", user_id || project.user_id)
    end
  end
end
