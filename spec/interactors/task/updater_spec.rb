# frozen_string_literal: true

# spring rspec spec/interactors/task/updater_spec.rb
RSpec.describe Task::Updater, instance_name: :updater do
  let(:updater) { described_class.new(params: params) }

  let(:task) { create(:task) }

  describe "#call" do
    subject(:call) { updater.call }

    context "when Task from :id param can not be found" do
      let(:params) { {id: 0} }

      it "returns the NotFound type of failure outcome hash" do
        is_expected.to eq(success: false, task: nil)
      end
    end

    context "when Task from :id param can be found but update fails (no title)" do
      let(:params) { {id: task.id, title: ""} }

      it "returns the regular failure with errors outcome hash" do
        is_expected.to match(success: false, task: an_instance_of(Task))
      end
    end

    context "when Task from :id param can be found but update succeeds" do
      let(:params) do
        {id: task.id, title: "new title", tags: ["urgent", first_tag_title]}
      end

      let(:task) { create(:task, :with_tags) }
      let(:first_tag_title) { task.tags.first.title }

      it "adds new tag, removes one of the existing tags and returns the success outcome hash" do
        expect{ call }.to(
          change{ task.reload.title }.to("new title").
          and change{ task.reload.tags.pluck(:title) }.to([first_tag_title, "urgent"])
        )

        is_expected.to match(success: true, task: an_instance_of(Task))
      end
    end
  end
end
