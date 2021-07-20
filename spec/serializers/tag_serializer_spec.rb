# frozen_string_literal: true

# spring rspec spec/serializers/tag_serializer_spec.rb
RSpec.describe TagSerializer do
  describe "#serializable_hash" do
    subject(:serializable_hash) { described_class.new(tag).serializable_hash }

    let(:tag) { build_stubbed(:tag, title: "test tag", id: 123) }

    it "returns a serializable hash with correct keys" do
      is_expected.to match(
        created_at: anything,
        id: 123,
        title: "test tag",
        updated_at: anything
      )
    end
  end
end
