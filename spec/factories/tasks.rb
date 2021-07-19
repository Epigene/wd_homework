# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    sequence(:title, 1) { |n| "task_#{n}" }

    trait :with_tags do
      after(:create) do |task|
        create_list(:task_tag, 2, task: task)
      end
    end
  end
end
