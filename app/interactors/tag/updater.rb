# frozen_string_literal: true

# Tag record change operation
class Tag::Updater
  include ServiceApi

  PERMITTED_KEYS = Tag::Creator::PERMITTED_KEYS

  # initializer
  def initialize(params:)
    @id = params[:id]
    @params = params.except(:id)
  end

  # @return [Hash]
  #  OK: {success: true, tag: Tag}
  #  NotFound: {success: false, tag: nil}
  #  Errors: {success: false, tag: Tag(with errors)}
  def call
    return {success: false, tag: nil} if tag.blank?

    success = tag.update(@params.slice(*PERMITTED_KEYS))

    {success: success, tag: tag}
  end

  private

    def tag
      return @tag if defined?(@tag)

      @tag = Tag.find_by(id: @id)
    end
end
