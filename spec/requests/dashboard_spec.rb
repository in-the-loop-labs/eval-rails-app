# SPDX-License-Identifier: MIT
# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard", type: :request do
  let(:user) { create(:user) }

  describe "GET /dashboard" do
    context "when authenticated" do
      before { sign_in user }

      it "returns a successful response" do
        create(:project, user: user)

        get dashboard_path

        expect(response).to have_http_status(:ok)
      end

      it "displays project statistics" do
        project = create(:project, user: user)
        create(:task, project: project, user: user, status: :completed)
        create(:task, project: project, user: user, status: :pending)

        get dashboard_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Dashboard")
        expect(response.body).to include("Total Tasks")
        expect(response.body).to include("Completion Rate")
      end
    end

    context "when not authenticated" do
      it "redirects to sign in" do
        get dashboard_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
