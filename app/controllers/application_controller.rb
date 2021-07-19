# frozen_string_literal: true

# Abstract parent controller for all app controllers
class ApplicationController < ActionController::API
  private

    # @return [Hash] # opting out of strong parameters
    def clean_params
      params.permit!.to_hash.deep_symbolize_keys
    end

    # This is a very naive handling of invalid create/update response
    # @return [Array<Hash>]
    def invalid_record_errors(record)
      record.errors.map do |invalid_field, message| #=> [:name, "can't be blank"]
        {
          "status" => "422",
          "source" => {"pointer" => "/data/attributes/#{invalid_field}"},
          "title" => "Invalid Attribute",
          "detail" => message
        }
      end
    end
end
