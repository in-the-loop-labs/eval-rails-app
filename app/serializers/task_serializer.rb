# frozen_string_literal: true
# SPDX-License-Identifier: MIT

class TaskSerializer
  attr_reader :task

  def initialize(task)
    @task = task
  end

  def as_json(_options = {})
    {
      id: task.id,
      title: task.title,
      description: task.description,
      status: task.status,
      priority: task.priority,
      due_date: task.due_date,
      created_at: task.created_at,
      updated_at: task.updated_at,
      user: serialize_user(task.user),
      project_id: task.project_id
    }
  end

  private

  def serialize_user(user)
    return nil unless user

    {
      id: user.id,
      name: user.name,
      email: user.email
    }
  end
end
