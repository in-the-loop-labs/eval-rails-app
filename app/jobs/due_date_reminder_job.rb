# SPDX-License-Identifier: MIT
# frozen_string_literal: true

class DueDateReminderJob < ApplicationJob
  queue_as :default

  def perform
    tasks = Task.where(status: [:pending, :in_progress])
                .where("due_date BETWEEN ? AND ?", Date.current, Date.current + 1.day)

    tasks.each do |task|
      next unless task.user.present?

      Notification.create!(
        recipient: task.user,
        actor: task.project.user,
        task: task,
        action: "due_date_reminder",
        message: "Task '#{task.title}' is due #{task.due_date == Date.current ? 'today' : 'tomorrow'}"
      )
    end
  end
end
