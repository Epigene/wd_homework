# frozen_string_literal: true

FactoryBot.define do
  factory :tag do
    sequence(:title, 1) { |n| "tag_#{n}" }
  end
end
