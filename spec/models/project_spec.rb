# SPDX-License-Identifier: MIT
# frozen_string_literal: true

require "rails_helper"

RSpec.describe Project do
  subject(:project) { build(:project) }

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id).case_insensitive }
    it { is_expected.to validate_presence_of(:status) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:status).with_values(active: 0, archived: 1, completed: 2) }
  end

  describe "scopes" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    describe ".active" do
      it "returns only active projects" do
        active_project = create(:project, user: user, status: :active)
        create(:project, :archived, user: user)

        expect(described_class.active).to eq([active_project])
      end
    end

    describe ".archived" do
      it "returns only archived projects" do
        create(:project, user: user, status: :active)
        archived_project = create(:project, :archived, user: user)

        expect(described_class.archived).to eq([archived_project])
      end
    end

    describe ".by_user" do
      it "returns projects belonging to the given user" do
        user_project = create(:project, user: user)
        create(:project, user: other_user)

        expect(described_class.by_user(user)).to eq([user_project])
      end
    end

    describe ".recently_updated" do
      it "returns projects ordered by updated_at descending" do
        old_project = create(:project, user: user, updated_at: 2.days.ago)
        new_project = create(:project, user: user, updated_at: 1.hour.ago)

        expect(described_class.recently_updated).to eq([new_project, old_project])
      end
    end

    describe ".search_by_name" do
      it "returns projects matching the search query" do
        matching = create(:project, user: user, name: "TaskFlow Backend")
        create(:project, user: user, name: "Other Thing")

        expect(described_class.search_by_name("taskflow")).to eq([matching])
      end

      it "is case-insensitive" do
        project = create(:project, user: user, name: "My Project")

        expect(described_class.search_by_name("MY PROJECT")).to include(project)
      end
    end
  end

  describe "#owned_by?" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it "returns true when the user owns the project" do
      project = create(:project, user: user)
      expect(project.owned_by?(user)).to be true
    end

    it "returns false when the user does not own the project" do
      project = create(:project, user: user)
      expect(project.owned_by?(other_user)).to be false
    end
  end
end
