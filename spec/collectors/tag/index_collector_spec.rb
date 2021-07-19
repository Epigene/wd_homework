# frozen_string_literal: true

# spring rspec spec/collectors/tag/index_collector_spec.rb
RSpec.describe Tag::IndexCollector do
  let(:collector) { described_class.new(params: params) }

  describe "#call" do
    subject(:call) { collector.call }

    context "when " do
      it "returns TODO" do
        expect(0).to eq(1)
      end
    end
  end
end
