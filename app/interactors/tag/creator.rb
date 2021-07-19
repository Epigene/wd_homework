# frozen_string_literal: true

# Tag record creation operation
class Tag::Creator
  include ServiceApi

  PERMITTED_KEYS = %i[
    title
  ].freeze

  # initializer
  def initialize(params:)
    @params = params
  end

  # @return [Hash]
  def call
    tag = Tag.new(@params.slice(*PERMITTED_KEYS))

    success = tag.save

    {success: success, tag: tag}
  end
end
