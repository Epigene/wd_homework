# frozen_string_literal: true

# spring rspec spec/collectors/task/index_collector_spec.rb
RSpec.describe Task::IndexCollector, instance_name: :collector do
  let(:collector) { described_class.new(params: {}) }

  describe "#call" do
    subject(:call) { collector.call }

    let!(:task) { create(:task) }

    it "returns a paginated array of Task records" do
      is_expected.to eq([task])
    end
  end
end
