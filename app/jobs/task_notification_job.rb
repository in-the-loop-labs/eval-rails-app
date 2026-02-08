# SPDX-License-Identifier: MIT
# frozen_string_literal: true

class TaskNotificationJob < ApplicationJob
  queue_as :default

  def perform(task_id, event_type, triggered_by_id)
    task = Task.find(task_id)
    triggered_by = User.find(triggered_by_id)

    case event_type
    when "assigned"
      return unless task.user.present?

      notification = Notification.create!(
        recipient: task.user,
        actor: triggered_by,
        task: task,
        action: "assigned",
        message: "#{triggered_by.name} assigned you to task '#{task.title}'"
      )
      deliver_message(notification)

    when "status_changed"
      recipients = User.all
      recipients.each do |user|
        next if user.id == triggered_by.id

        notification = Notification.create!(
          recipient: user,
          actor: triggered_by,
          task: task,
          action: "status_changed",
          message: "#{triggered_by.name} changed status of '#{task.title}' to #{task.status}"
        )
        send_notification(notification)
      end

    when "commented"
      notify_users = [task.user, task.project.user].compact.uniq
      notify_users.reject! { |u| u.id == triggered_by.id }

      notify_users.each do |user|
        notification = Notification.create!(
          recipient: user,
          actor: triggered_by,
          task: task,
          action: "commented",
          message: "#{triggered_by.name} commented on '#{task.title}'"
        )
        notify_user(notification)
      end
    end
  end

  private

  def deliver_message(notification)
    notification.update(read: false)
    # In production, this would send an email/push notification
    Rails.logger.info("Notification delivered: #{notification.message}")
  end

  def send_notification(notification)
    notification.update(read: false)
    Rails.logger.info("Notification sent: #{notification.message}")
  end

  def notify_user(notification)
    notification.update(read: false)
    Rails.logger.info("User notified: #{notification.message}")
  end
end
