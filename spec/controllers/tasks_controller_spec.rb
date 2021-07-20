# frozen_string_literal: true

# spring rspec spec/controllers/tasks_controller_spec.rb
RSpec.describe TasksController, type: :request do
  describe "GET :index" do
    subject(:make_request) { get "/api/v1/tasks", params: params }

    let(:params) { {} }

    it "responds with JSON representation of whatever data Task::IndexCollector call provides" do
      expect(Task::IndexCollector).to(
        receive(:call).once.and_return(
          [
            {
              id: 1,
              created_at: "2021-07-19 12:00",
              updated_at: "2021-07-19 13:00",
              title: "Eat breakfast",
              tags: ["high priority"]
            }
          ]
        )
      )

      make_request

      expect(response.code).to eq("200")

      expect(response.body).to eq(
        '[{"id":1,"created_at":"2021-07-19 12:00","updated_at":"2021-07-19 13:00",'\
        '"title":"Eat breakfast","tags":["high priority"]}]'
      )
    end
  end

  describe "POST :create" do
    subject(:make_request) { post "/api/v1/tasks", params: params }

    let(:params) { {test: "task"} }

    before { Timecop.freeze("2021-01-10 12:00") }

    context "when creation succeeds and outcome is a :success" do
      let(:successful_outcome) { {success: true, task: task} }
      let(:task) { build_stubbed(:task, id: 1001, title: "homework1") }

      it "responds with JSON representation of the created record" do
        expect(Task::Creator).to(
          receive(:call).with(params: hash_including(test: "task")).once.
          and_return(successful_outcome)
        )

        make_request

        expect(response.code).to eq("200")

        expect(response.body).to eq(
          '{"id":1001,"created_at":"2021-01-10T12:00:00Z",'\
          '"updated_at":"2021-01-10T12:00:00Z","title":"homework1","tags":[]}'
        )
      end
    end

    context "when creation is not successful (some validation error)" do
      let(:unsuccessful_outcome) { {success: false, task: task} }
      let(:task) { instance_double("Task", errors: [[:title, "can't be blank"]]) }

      it "responds with :bad_request and validation errors" do
        expect(Task::Creator).to(
          receive(:call).with(params: hash_including(test: "task")).once.
          and_return(unsuccessful_outcome)
        )

        make_request

        expect(response.code).to eq("400")
        expect(response.body).to contain('"errors":')
      end
    end
  end

  describe "PUT :update" do
    subject(:make_request) { put "/api/v1/tasks/#{id}", params: params }

    let(:id) { 123 }
    let(:params) { {test: "task"} }

    before { Timecop.freeze("2021-01-12 12:00") }

    context "when updating succeeds and outcome is a :success" do
      let(:successful_outcome) { {success: true, task: task} }
      let(:task) { create(:task, :with_tags, id: 1002, title: "homework2") }
      let(:tag1) { task.tags.first.title }
      let(:tag2) { task.tags.second.title }

      it "responds with JSON representation of the updated record" do
        expect(Task::Updater).to(
          receive(:call).with(params: hash_including(test: "task")).once.
          and_return(successful_outcome)
        )

        make_request

        expect(response.code).to eq("200")

        expect(response.body).to eq(
          "{\"id\":1002,\"created_at\":\"2021-01-12T12:00:00Z\","\
          "\"updated_at\":\"2021-01-12T12:00:00Z\",\"title\":\"homework2\","\
          "\"tags\":[\"#{tag1}\",\"#{tag2}\"]}"
        )
      end
    end

    context "when creation is not successful (some validation error)" do
      let(:unsuccessful_outcome) { {success: false, task: task} }
      let(:task) { instance_double("Task", errors: [[:title, "can't be blank"]]) }

      it "responds with :bad_request and validation errors" do
        expect(Task::Updater).to(
          receive(:call).with(params: hash_including(test: "task")).once.
          and_return(unsuccessful_outcome)
        )

        make_request

        expect(response.code).to eq("400")
        expect(response.body).to contain('"errors":')
      end
    end

    context "when there is no record by id specified in request params" do
      let(:not_found_outcome) { {success: false, task: nil} }

      it "responds with 404, not found" do
        expect(Task::Updater).to(
          receive(:call).with(params: hash_including(test: "task")).once.
          and_return(not_found_outcome)
        )

        make_request

        expect(response.code).to eq("404")
        expect(response.body).to eq("{}")
      end
    end
  end
end
