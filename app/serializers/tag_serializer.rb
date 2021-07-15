# frozen_string_literal: true

class TagSerializer < ActiveModel::Serializer
  attribute :id
  attribute :created_at
  attribute :updated_at
  attribute :title
end
