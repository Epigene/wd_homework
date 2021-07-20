# frozen_string_literal: true

# spring rspec spec/interactors/task/creator_spec.rb
RSpec.describe Task::Creator, instance_name: :creator do
  let(:creator) { described_class.new(params: params) }

  describe "#call" do
    subject(:call) { creator.call }

    context "when initialized with insufficient params" do
      let(:params) { {} }

      it "returns a failure outcome (no title)" do
        is_expected.to match(success: false, task: an_instance_of(Task))
      end
    end

    context "when initialized with OK params" do
      let(:params) { {title: "My first tag", tags: %w[home test]} }

      it "creates a new tag record, returns a success outcome" do
        expect{ call }.to(
          change{ Task.count }.by(1).
          and change{ Tag.count }.by(2)
        )

        is_expected.to match(success: true, task: an_instance_of(Task))
      end
    end
  end
end
