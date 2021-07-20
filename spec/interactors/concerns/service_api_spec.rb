# frozen_string_literal: true

# spring rspec spec/interactors/concerns/service_api_spec.rb
RSpec.describe ServiceApi do
  let(:includer) do
    Class.new do
      include ServiceApi

      def initialize(arg1:, arg2:)
        @arg1 = arg1
        @arg2 = arg2
      end

      def call
        @arg1 + @arg2
      end
    end
  end

  describe ".call" do
    subject(:call) { includer.call(arg1: 1, arg2: 2) }

    it { is_expected.to eq(3) }
  end
end
