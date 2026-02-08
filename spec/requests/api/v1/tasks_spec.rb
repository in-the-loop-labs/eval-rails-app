# frozen_string_literal: true
# SPDX-License-Identifier: MIT

require "rails_helper"

RSpec.describe "Api::V1::Tasks", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project, user: user) }

  let(:valid_attributes) do
    {
      title: "New API Task",
      description: "Created via API",
      status: "pending",
      priority: "medium"
    }
  end

  describe "GET /api/v1/projects/:project_id/tasks" do
    before { sign_in user }

    it "returns a list of tasks for the project" do
      create_list(:task, 3, project: project, user: user)

      get api_v1_project_tasks_path(project)

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.length).to eq(3)
      expect(json.first).to have_key("title")
      expect(json.first).to have_key("status")
    end

    it "filters tasks by status" do
      create(:task, project: project, user: user, status: :pending)
      create(:task, project: project, user: user, status: :completed)

      get api_v1_project_tasks_path(project), params: { status: "pending" }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
      expect(json.first["status"]).to eq("pending")
    end

    it "requires authentication" do
      get api_v1_project_tasks_path(project)

      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET /api/v1/projects/:project_id/tasks/:id" do
    it "returns the task details" do
      get api_v1_project_task_path(project, task)

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["id"]).to eq(task.id)
      expect(json["title"]).to eq(task.title)
    end
  end

  describe "POST /api/v1/projects/:project_id/tasks" do
    before { sign_in user }

    it "creates a new task" do
      expect {
        post api_v1_project_tasks_path(project),
             params: { task: valid_attributes },
             as: :json
      }.to change(Task, :count).by(1)

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["title"]).to eq("New API Task")
    end

    it "returns errors for invalid task" do
      post api_v1_project_tasks_path(project),
           params: { task: { title: "", status: "invalid" } },
           as: :json

      expect(response).to have_http_status(:unprocessable_entity)

      json = JSON.parse(response.body)
      expect(json).to have_key("errors")
    end
  end

  describe "PATCH /api/v1/projects/:project_id/tasks/:id" do
    before { sign_in user }

    it "updates the task" do
      patch api_v1_project_task_path(project, task),
            params: { task: { title: "Updated Title" } },
            as: :json

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["title"]).to eq("Updated Title")
    end
  end

  describe "DELETE /api/v1/projects/:project_id/tasks/:id" do
    before { sign_in user }

    it "deletes the task" do
      task # ensure task exists before the expect block

      expect {
        delete api_v1_project_task_path(project, task), as: :json
      }.to change(Task, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
