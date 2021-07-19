# frozen_string_literal: true

# spring rspec spec/models/task_tag_spec.rb
RSpec.describe TaskTag, type: :model do
  describe "associations" do
    it do
      is_expected.to belong_to(:tag)
      is_expected.to belong_to(:task)
    end
  end

  describe "validations" do
    it do
      is_expected.to validate_presence_of(:tag_id)
      is_expected.to validate_presence_of(:task_id)
    end
  end
end
