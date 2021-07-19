# frozen_string_literal: true

# spring rspec spec/interactors/tag/updater_spec.rb
RSpec.describe Tag::Updater do
  let(:updater) { described_class.new(params: params) }

  let(:tag) { create(:tag) }

  describe "#call" do
    subject(:call) { updater.call }

    context "when Tag from :id param can not be found" do
      let(:params) { {id: 0} }

      it "returns the NotFound type of failure outcome hash" do
        is_expected.to eq(success: false, tag: nil)
      end
    end

    context "when Tag from :id param can be found but update fails (no title)" do
      let(:params) { {id: tag.id, title: ""} }

      it "returns the regular failure with errors outcome hash" do
        is_expected.to match(success: false, tag: an_instance_of(Tag))
      end
    end

    context "when Tag from :id param can be found but update succeeds" do
      let(:params) { {id: tag.id, title: "new title"} }

      it "returns the success outcome hash" do
        expect{ call }.to change{ tag.reload.title }.to("new title")

        is_expected.to match(success: true, tag: an_instance_of(Tag))
      end
    end
  end
end
