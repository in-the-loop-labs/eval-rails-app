# SPDX-License-Identifier: MIT
# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence(word_count: 4) }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    status { :pending }
    priority { :medium }
    project
    user

    trait :in_progress do
      status { :in_progress }
    end

    trait :completed do
      status { :completed }
    end

    trait :cancelled do
      status { :cancelled }
    end

    trait :low_priority do
      priority { :low }
    end

    trait :high_priority do
      priority { :high }
    end

    trait :urgent do
      priority { :urgent }
    end

    trait :overdue do
      due_date { 3.days.ago.to_date }
    end

    trait :due_soon do
      due_date { 2.days.from_now.to_date }
    end

    trait :unassigned do
      user { nil }
    end
  end
end
