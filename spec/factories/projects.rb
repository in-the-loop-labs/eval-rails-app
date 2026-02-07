# SPDX-License-Identifier: MIT
# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    name { Faker::App.unique.name }
    description { Faker::Lorem.paragraph(sentence_count: 3) }
    status { :active }
    user

    trait :archived do
      status { :archived }
    end

    trait :completed do
      status { :completed }
    end

    trait :with_long_description do
      description { Faker::Lorem.paragraphs(number: 10).join("\n\n") }
    end
  end
end
