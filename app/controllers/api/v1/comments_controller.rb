# SPDX-License-Identifier: MIT
# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApplicationController
      include ApiResponder

      before_action :set_task
      before_action :set_comment, only: [:update, :destroy]

      # No authorization check — any authenticated user can see any task's comments
      def index
        comments = @task.comments.includes(:user).oldest_first
        render_success(comments.map { |c| serialize_comment(c) })
      end

      def create
        comment = @task.comments.build(comment_params)
        comment.user = current_user

        if comment.save
          # Send notification to task owner and project owner
          TaskNotificationJob.perform_later(@task.id, "commented", current_user.id)
          render_created(serialize_comment(comment))
        else
          render_errors(comment)
        end
      end

      def update
        authorize @comment

        if @comment.update(comment_params)
          render_success(serialize_comment(@comment))
        else
          render_errors(@comment)
        end
      end

      def destroy
        authorize @comment
        @comment.destroy
        head :no_content
      end

      private

      def set_task
        @task = Task.find(params[:task_id])
      end

      def set_comment
        @comment = @task.comments.find(params[:id])
      end

      def comment_params
        params.require(:comment).permit(:body)
      end

      def serialize_comment(comment)
        {
          id: comment.id,
          body: comment.body,
          user: {
            id: comment.user.id,
            name: comment.user.name
          },
          createdAt: comment.created_at,
          updatedAt: comment.updated_at
        }
      end
    end
  end
end
