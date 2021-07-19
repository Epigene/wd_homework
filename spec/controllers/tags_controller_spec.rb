# frozen_string_literal: true

# spring rspec spec/controllers/tags_controller_spec.rb
RSpec.describe TagsController, type: :request do
  describe "GET :index" do
    subject(:make_request) { get "/api/v1/tags", params: params }

    let(:params) { {} }

    it "responds with JSON representation of whatever data Tag::IndexCollector call provides" do
      expect(Tag::IndexCollector).to(
        receive(:call).once.and_return(
          [
            {
              id: 1,
              created_at: "2021-07-19 12:00",
              updated_at: "2021-07-19 13:00",
              title: "Homework"
            }
          ]
        )
      )

      make_request

      expect(response.code).to eq("200")

      expect(response.body).to eq(
        '[{"id":1,"created_at":"2021-07-19 12:00","updated_at":"2021-07-19 13:00",'\
        '"title":"Homework"}]'
      )
    end
  end

  describe "POST :create" do
    subject(:make_request) { post "/api/v1/tags", params: params }

    let(:params) { {test: "t"} }

    before { Timecop.freeze("2021-01-10 12:00") }

    context "when creation succeeds and outcome is a :success" do
      let(:successful_outcome) { {success: true, tag: tag} }
      let(:tag) { build_stubbed(:tag, id: 1001, title: "tag_1") }

      it "responds with JSON representation of the created record" do
        expect(Tag::Creator).to(
          receive(:call).with(params: hash_including(test: "t")).once.
          and_return(successful_outcome)
        )

        make_request

        expect(response.code).to eq("200")

        expect(response.body).to eq(
          '{"tag":{"id":1001,"created_at":"2021-01-10T12:00:00Z",'\
          '"updated_at":"2021-01-10T12:00:00Z","title":"tag_1"}}'
        )
      end
    end

    context "when creation is not successful (some validation error)" do
      let(:unsuccessful_outcome) { {success: false, tag: tag} }
      let(:tag) { instance_double("Tag", errors: [[:title, "can't be blank"]]) }

      it "responds with :bad_request and validation errors" do
        expect(Tag::Creator).to(
          receive(:call).with(params: hash_including(test: "t")).once.
          and_return(unsuccessful_outcome)
        )

        make_request

        expect(response.code).to eq("400")
        expect(response.body).to contain('"errors":')
      end
    end
  end

  describe "PUT :update" do
    subject(:make_request) { put "/api/v1/tags/#{id}", params: params }

    let(:id) { 123 }
    let(:params) { {test: "t"} }

    before { Timecop.freeze("2021-01-12 12:00") }

    context "when updating succeeds and outcome is a :success" do
      let(:successful_outcome) { {success: true, tag: tag} }
      let(:tag) { build_stubbed(:tag, id: 1002, title: "tag_2") }

      it "responds with JSON representation of the updated record" do
        expect(Tag::Updater).to(
          receive(:call).with(params: hash_including(test: "t")).once.
          and_return(successful_outcome)
        )

        make_request

        expect(response.code).to eq("200")

        expect(response.body).to eq(
          '{"tag":{"id":1002,"created_at":"2021-01-12T12:00:00Z",'\
          '"updated_at":"2021-01-12T12:00:00Z","title":"tag_2"}}'
        )
      end
    end

    context "when creation is not successful (some validation error)" do
      let(:unsuccessful_outcome) { {success: false, tag: tag} }
      let(:tag) { instance_double("Tag", errors: [[:title, "can't be blank"]]) }

      it "responds with :bad_request and validation errors" do
        expect(Tag::Updater).to(
          receive(:call).with(params: hash_including(test: "t")).once.
          and_return(unsuccessful_outcome)
        )

        make_request

        expect(response.code).to eq("400")
        expect(response.body).to contain('"errors":')
      end
    end
  end
end
