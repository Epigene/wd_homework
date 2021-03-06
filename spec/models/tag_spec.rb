# frozen_string_literal: true

# spring rspec spec/models/tag_spec.rb
RSpec.describe Tag, type: :model do
  describe "associations" do
    it do
      is_expected.to have_many(:task_tags)
      is_expected.to have_many(:tasks)
    end
  end

  describe "validations" do
    it do
      is_expected.to validate_presence_of(:title)
      is_expected.to validate_uniqueness_of(:title)
    end
  end
end
