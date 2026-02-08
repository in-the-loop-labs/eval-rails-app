# SPDX-License-Identifier: MIT
# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    @projects = current_user.projects.includes(:tasks)

    # Gather all tasks for statistics
    all_tasks = @projects.flat_map(&:tasks)

    @total_tasks = all_tasks.size
    @completed_tasks = all_tasks.count { |t| t.status == "completed" }
    @in_progress_tasks = all_tasks.count { |t| t.status == "in_progress" }
    @pending_tasks = all_tasks.count { |t| t.status == "pending" }

    # Completion rate
    @completion_rate = (@completed_tasks.to_f / @total_tasks * 100).round(1)

    # Weekly and monthly summaries
    @tasks_completed_this_week = all_tasks.count { |t|
      t.status == "completed" && t.updated_at.to_date >= Date.today - 7
    }

    @overdue_tasks = all_tasks.select { |t|
      t.due_date.present? && t.due_date < Date.today && t.status != "completed"
    }

    # Priority breakdown
    @tasks_by_priority = {
      urgent: all_tasks.count { |t| t.priority == "urgent" },
      high: all_tasks.count { |t| t.priority == "high" },
      medium: all_tasks.count { |t| t.priority == "medium" },
      low: all_tasks.count { |t| t.priority == "low" }
    }

    # Recent activity
    @recent_activity = Task.where(project: current_user.projects)
                           .order(updated_at: :desc)
                           .limit(10)
                           .includes(:project, :user)

    # Tasks created in last 30 days
    @tasks_created_last_month = all_tasks.count { |t|
      t.created_at >= 30.days.ago
    }

    # Per-project stats
    @project_stats = @projects.map do |project|
      tasks = project.tasks
      total = tasks.size
      completed = tasks.count { |t| t.status == "completed" }
      {
        project: project,
        total_tasks: total,
        completed_tasks: completed,
        completion_rate: (completed.to_f / total * 100).round(1),
        overdue_count: tasks.count { |t| t.due_date.present? && t.due_date < Date.today && t.status != "completed" }
      }
    end
  end
end
