# SPDX-License-Identifier: MIT
# frozen_string_literal: true

require "rails_helper"

RSpec.describe TaskNotificationJob, type: :job do
  let(:project) { create(:project) }
  let(:user) { create(:user) }
  let(:assignee) { create(:user) }
  let(:task) { create(:task, project: project, user: assignee) }

  describe "#perform" do
    context "when event is assigned" do
      it "creates a notification for the assignee" do
        expect {
          described_class.new.perform(task.id, "assigned", user.id)
        }.to change(Notification, :count).by(1)
      end

      it "sets the correct notification attributes" do
        described_class.new.perform(task.id, "assigned", user.id)

        notification = Notification.last
        expect(notification.recipient).to eq(assignee)
        expect(notification.actor).to eq(user)
        expect(notification.action).to eq("assigned")
      end
    end

    context "when event is status_changed" do
      it "creates notifications for other users" do
        other_user = create(:user)

        expect {
          described_class.new.perform(task.id, "status_changed", user.id)
        }.to change(Notification, :count).by_at_least(1)
      end
    end

    context "when event is commented" do
      it "creates notifications for relevant users" do
        expect {
          described_class.new.perform(task.id, "commented", user.id)
        }.to change(Notification, :count).by_at_least(1)
      end
    end

    context "when task has no assignee" do
      let(:unassigned_task) { create(:task, project: project, user: nil) }

      it "does not create a notification for assigned event" do
        expect {
          described_class.new.perform(unassigned_task.id, "assigned", user.id)
        }.not_to change(Notification, :count)
      end
    end
  end

  describe "queue" do
    it "uses the default queue" do
      expect(described_class.new.queue_name).to eq("default")
    end
  end
end
