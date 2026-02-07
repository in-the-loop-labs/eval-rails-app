# SPDX-License-Identifier: MIT
# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  subject(:user) { build(:user) }

  describe "associations" do
    it { is_expected.to have_many(:projects).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(100) }
    it { is_expected.to validate_length_of(:email).is_at_most(255) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe "scopes" do
    describe ".alphabetical" do
      it "returns users ordered by name" do
        charlie = create(:user, name: "Charlie")
        alice = create(:user, name: "Alice")
        bob = create(:user, name: "Bob")

        expect(described_class.alphabetical).to eq([alice, bob, charlie])
      end
    end

    describe ".recently_created" do
      it "returns users ordered by creation date descending" do
        old_user = create(:user, created_at: 2.days.ago)
        new_user = create(:user, created_at: 1.hour.ago)

        expect(described_class.recently_created).to eq([new_user, old_user])
      end
    end
  end

  describe "#display_name" do
    it "returns the name when present" do
      user = build(:user, name: "Alice Johnson")
      expect(user.display_name).to eq("Alice Johnson")
    end

    it "returns the email when name is blank" do
      user = build(:user, name: "", email: "alice@example.com")
      expect(user.display_name).to eq("alice@example.com")
    end
  end
end
