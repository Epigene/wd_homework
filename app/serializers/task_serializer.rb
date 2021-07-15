# frozen_string_literal: true

class TaskSerializer < ActiveModel::Serializer
  attribute :id
  attribute :created_at
  attribute :updated_at
  attribute :title
  attribute :tags

  # Rather than serializing the whole :tags association, merely returning an array of tag titles
  # @return [Array]
  def tags
    ["TODO"]
  end
end
