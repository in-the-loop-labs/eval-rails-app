# SPDX-License-Identifier: MIT
# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraph(sentence_count: 2) }
    task
    user
  end
end
