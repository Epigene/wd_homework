# frozen_string_literal: true

# Serializer for Taks resources
class TaskSerializer < ActiveModel::Serializer
  attribute :id
  attribute :created_at
  attribute :updated_at
  attribute :title
  attribute :tags

  # Rather than serializing the whole :tags association, merely returning an array of tag titles
  # @return [Array]
  def tags
    object.tags.pluck(:title).sort
  end
end
