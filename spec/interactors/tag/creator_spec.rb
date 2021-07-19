# frozen_string_literal: true

# spring rspec spec/interactors/tag/creator_spec.rb
RSpec.describe Tag::Creator do
  let(:creator) { described_class.new(params: params) }

  describe "#call" do
    subject(:call) { creator.call }

    context "when initialized with insufficient params" do
      let(:params) { {} }

      it "returns a failure outcome (no title)" do
        is_expected.to match(success: false, tag: an_instance_of(Tag))
      end
    end

    context "when initialized with OK params" do
      let(:params) { {title: "My first tag"} }

      it "creates a new tag record, returns a success outcome" do
        expect{ call }.to change{ Tag.count }.by(1)

        is_expected.to match(success: true, tag: an_instance_of(Tag))
      end
    end
  end
end
