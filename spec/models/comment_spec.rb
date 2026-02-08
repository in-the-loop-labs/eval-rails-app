# SPDX-License-Identifier: MIT
# frozen_string_literal: true

require "rails_helper"

RSpec.describe Comment do
  subject(:comment) { build(:comment) }

  describe "associations" do
    it { is_expected.to belong_to(:task) }
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_length_of(:body).is_at_most(10_000) }
  end

  describe "scopes" do
    let(:user) { create(:user) }
    let(:project) { create(:project, user: user) }
    let(:task) { create(:task, project: project) }

    describe ".recent" do
      it "returns comments ordered by created_at descending" do
        old_comment = create(:comment, task: task, user: user, created_at: 2.days.ago)
        new_comment = create(:comment, task: task, user: user, created_at: 1.hour.ago)

        expect(described_class.recent).to eq([new_comment, old_comment])
      end
    end

    describe ".oldest_first" do
      it "returns comments ordered by created_at ascending" do
        old_comment = create(:comment, task: task, user: user, created_at: 2.days.ago)
        new_comment = create(:comment, task: task, user: user, created_at: 1.hour.ago)

        expect(described_class.oldest_first).to eq([old_comment, new_comment])
      end
    end
  end
end
