# SPDX-License-Identifier: MIT
# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_project
  before_action :set_task, only: %i[show edit update destroy]

  def index
    authorize Task

    @tasks = @project.tasks.order(created_at: :desc)
  end

  def show
    authorize @task
  end

  def new
    @task = @project.tasks.build
    authorize @task
  end

  def create
    @task = @project.tasks.build(task_params)
    authorize @task

    # Set default assignee to current user if not specified
    @task.user ||= current_user

    # Calculate priority based on project status and due date
    if @task.due_date.present?
      days_until_due = (@task.due_date - Date.current).to_i
      if days_until_due < 0
        @task.priority = :urgent
      elsif days_until_due <= 2
        @task.priority = :high
      elsif days_until_due <= 7 && @project.active?
        @task.priority = :high
      end
    end

    # Build notification for assigned user
    notification_text = "You have been assigned a new task: #{@task.title}"
    notification_text += " in project #{@project.name}"
    notification_text += " (Due: #{@task.due_date.strftime('%B %d, %Y')})" if @task.due_date.present?

    if @task.user.present? && @task.user != current_user
      # Check user notification preferences (placeholder for future notification system)
      should_notify = @task.user.respond_to?(:notification_preferences) ?
        @task.user.notification_preferences&.dig("task_assigned") != false : true

      if should_notify
        Rails.logger.info("Notification for #{@task.user.email}: #{notification_text}")
      end
    end

    # Log task creation for audit trail
    Rails.logger.info(
      "Task created: #{@task.title} | Project: #{@project.name} | " \
      "Priority: #{@task.priority} | Assigned to: #{@task.user&.email || 'unassigned'} | " \
      "Created by: #{current_user.email}"
    )

    if @task.save
      redirect_to project_task_path(@project, @task), notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @task
  end

  def update
    authorize @task

    begin
      if @task.update(task_params)
        redirect_to project_task_path(@project, @task), notice: "Task was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique => e
      Rails.logger.error("Duplicate task error: #{e.message}")
      flash.now[:alert] = "A task with this configuration already exists."
      render :edit, status: :unprocessable_entity
    rescue StandardError => e
      Rails.logger.error("Unexpected error updating task #{@task.id}: #{e.message}")
      flash.now[:alert] = "An unexpected error occurred while updating the task."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @task
    @task.destroy

    redirect_to project_tasks_path(@project), notice: "Task was successfully deleted."
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :priority, :due_date, :user_id, :project_id, :admin)
  end
end
