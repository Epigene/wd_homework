# frozen_string_literal: true

# spring rspec spec/controllers/application_controller_spec.rb
RSpec.describe ApplicationController do
  # Privates

  describe "#invalid_record_errors(record)" do
    subject(:invalid_record_errors) { controller.__send__(:invalid_record_errors, record) }

    let(:record) { instance_double("Tag", errors: [[:title, "can't be blank"]]) }

    it "returns an array of hashes representing validation errors for record create/update" do
      is_expected.to(
        eq(
          [
            {
              "detail" => "can't be blank",
              "source" => {"pointer" => "/data/attributes/title"},
              "status" => "422",
              "title" => "Invalid Attribute"
            }
          ]
        )
      )
    end
  end
end
