# SPDX-License-Identifier: MIT
# frozen_string_literal: true

require "rails_helper"

RSpec.describe Notification, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:recipient).class_name("User") }
    it { is_expected.to belong_to(:actor).class_name("User") }
    it { is_expected.to belong_to(:task) }
  end

  describe "factory" do
    it "creates a valid notification" do
      notification = build(:notification)
      expect(notification).to be_valid
    end

    it "supports the read trait" do
      notification = build(:notification, :read)
      expect(notification.read).to be true
    end
  end
end
