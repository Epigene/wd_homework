# frozen_string_literal: true

# spring rspec spec/serializers/task_serializer_spec.rb
RSpec.describe TaskSerializer do
  describe "#serializable_hash" do
    subject(:serializable_hash) { described_class.new(task).serializable_hash }

    let(:task) do
      create(:task, :with_tags, title: "test task", id: 456)
    end

    it "returns a serializable hash with correct keys" do
      is_expected.to match(
        created_at: anything,
        id: 456,
        tags: [task.tags.first.title, task.tags.second.title],
        title: "test task",
        updated_at: anything
      )
    end
  end
end
