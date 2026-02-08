# SPDX-License-Identifier: MIT
# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_project
  before_action :set_task
  before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    @comment = @task.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      # Send notification to task owner and project owner
      TaskNotificationJob.perform_later(@task.id, "commented", current_user.id)
      redirect_to project_task_path(@project, @task), notice: "Comment added."
    else
      # Reload comments for the view
      @comments = @task.comments.includes(:user).oldest_first
      render "tasks/show", status: :unprocessable_entity
    end
  end

  def edit
    authorize @comment
  end

  def update
    authorize @comment

    if @comment.update(comment_params)
      redirect_to project_task_path(@project, @task), notice: "Comment updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @comment
    @comment.destroy
    redirect_to project_task_path(@project, @task), notice: "Comment deleted."
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:task_id])
  end

  def set_comment
    @comment = @task.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
