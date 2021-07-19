# frozen_string_literal: true

# spring rspec spec/models/task_spec.rb
RSpec.describe Task, type: :model do
  describe "associations" do
    it do
      is_expected.to have_many(:task_tags)
      is_expected.to have_many(:tags)
    end
  end

  describe "validations" do
    it do
      is_expected.to validate_presence_of(:title)
    end
  end
end
