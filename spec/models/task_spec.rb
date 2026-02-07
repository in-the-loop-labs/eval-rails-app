# SPDX-License-Identifier: MIT
# frozen_string_literal: true

require "rails_helper"

RSpec.describe Task do
  subject(:task) { build(:task) }

  describe "associations" do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:user).optional }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:priority) }
    it { is_expected.to validate_length_of(:description).is_at_most(5000) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:status).with_values(pending: 0, in_progress: 1, completed: 2, cancelled: 3) }
    it { is_expected.to define_enum_for(:priority).with_values(low: 0, medium: 1, high: 2, urgent: 3) }
  end

  describe "scopes" do
    let(:user) { create(:user) }
    let(:project) { create(:project, user: user) }

    describe ".by_status" do
      it "returns tasks with the given status" do
        pending_task = create(:task, project: project, status: :pending)
        create(:task, :completed, project: project)

        expect(described_class.by_status(:pending)).to eq([pending_task])
      end
    end

    describe ".by_priority" do
      it "returns tasks with the given priority" do
        high_task = create(:task, :high_priority, project: project)
        create(:task, :low_priority, project: project)

        expect(described_class.by_priority(:high)).to eq([high_task])
      end
    end

    describe ".overdue" do
      it "returns non-completed tasks past their due date" do
        overdue_task = create(:task, :overdue, project: project)
        create(:task, :due_soon, project: project)
        create(:task, :overdue, :completed, project: project)

        expect(described_class.overdue).to eq([overdue_task])
      end
    end

    describe ".due_soon" do
      it "returns tasks due within 3 days" do
        soon_task = create(:task, :due_soon, project: project)
        create(:task, due_date: 10.days.from_now, project: project)

        expect(described_class.due_soon).to eq([soon_task])
      end
    end

    describe ".unassigned" do
      it "returns tasks without an assigned user" do
        unassigned_task = create(:task, :unassigned, project: project)
        create(:task, project: project, user: user)

        expect(described_class.unassigned).to eq([unassigned_task])
      end
    end

    describe ".assigned_to" do
      it "returns tasks assigned to the given user" do
        user_task = create(:task, project: project, user: user)
        create(:task, :unassigned, project: project)

        expect(described_class.assigned_to(user)).to eq([user_task])
      end
    end

    describe ".recently_created" do
      it "returns tasks ordered by created_at descending" do
        old_task = create(:task, project: project, created_at: 2.days.ago)
        new_task = create(:task, project: project, created_at: 1.hour.ago)

        expect(described_class.recently_created).to eq([new_task, old_task])
      end
    end
  end
end
