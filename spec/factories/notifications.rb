# SPDX-License-Identifier: MIT
# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    recipient { association(:user) }
    actor { association(:user) }
    task
    action { "assigned" }
    message { "You have been assigned a task" }
    read { false }

    trait :read do
      read { true }
    end

    trait :status_changed do
      action { "status_changed" }
      message { "Task status was changed" }
    end

    trait :commented do
      action { "commented" }
      message { "Someone commented on a task" }
    end

    trait :due_date_reminder do
      action { "due_date_reminder" }
      message { "A task is due soon" }
    end
  end
end
