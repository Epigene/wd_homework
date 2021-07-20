# frozen_string_literal: true

# spring rspec spec/collectors/tag/index_collector_spec.rb
RSpec.describe Tag::IndexCollector do
  let(:collector) { described_class.new(params: {}) }

  describe "#call" do
    subject(:call) { collector.call }

    let!(:tag) { create(:tag) }

    it "returns a paginated array of Tag records" do
      is_expected.to eq([tag])
    end
  end
end
