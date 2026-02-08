# frozen_string_literal: true
# SPDX-License-Identifier: MIT

module Api
  module V1
    class TasksController < ApplicationController
      skip_before_action :verify_authenticity_token
      skip_before_action :authenticate_user!, only: [:show]

      before_action :set_project
      before_action :set_task, only: [:show, :update, :destroy]

      def index
        authorize Task

        tasks = @project.tasks

        if params[:status].present?
          tasks = tasks.by_status(params[:status])
        end

        if params[:priority].present?
          tasks = tasks.by_priority(params[:priority])
        end

        render json: tasks.map { |t|
          {
            id: t.id,
            title: t.title,
            status: t.status,
            priority: t.priority,
            due_date: t.due_date,
            assignee: t.user&.name
          }
        }
      end

      def show
        render json: serialize_task(@task)
      end

      def create
        task = @project.tasks.build(task_params)
        task.user = current_user unless task_params[:user_id]

        authorize task

        if task.save
          render json: serialize_task(task), status: :created
        else
          render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize @task

        if @task.update(task_params)
          render json: serialize_task(@task)
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @task
        @task.destroy
        head :no_content
      end

      private

      def set_project
        @project = Project.find(params[:project_id])
      end

      def set_task
        @task = @project.tasks.find(params[:id])
      end

      def task_params
        params.require(:task).permit(:title, :description, :status, :priority, :due_date, :user_id)
      end

      def serialize_task(task)
        {
          id: task.id,
          title: task.title,
          description: task.description,
          status: task.status,
          priority: task.priority,
          dueDate: task.due_date,
          createdAt: task.created_at,
          updatedAt: task.updated_at,
          assignedUser: task.user ? {
            id: task.user.id,
            name: task.user.name,
            email: task.user.email
          } : nil,
          project_id: task.project_id
        }
      end
    end
  end
end
