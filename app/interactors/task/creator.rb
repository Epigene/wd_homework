# frozen_string_literal: true

# Task record creation operation
class Task::Creator
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
    task

    ActiveRecord::Base.transaction do
      success = task.save

      return {success: false, task: task} unless success

      ensure_tags!
    end

    {success: true, task: task.reload}
  end

  private

    def task
      @task ||= Task.new(@params.slice(*PERMITTED_KEYS))
    end

    def ensure_tags!
      return unless @params.key?(:tags)

      missing_tags = Array.wrap(@params[:tags]).to_set - existing_tag_data.to_set

      just_created_tag_ids =
        missing_tags.map do |tag_title, _id|
          Tag::Creator.call(params: {title: tag_title})[:tag].id
        end

      joinable_tag_ids = just_created_tag_ids + existing_tag_data.map(&:second)

      joinable_tag_ids.each do |tag_id|
        TaskTag.create!(task: task, tag_id: tag_id)
      end
    end

    def existing_tag_data
      Tag.where(title: @params[:tags]).pluck(:title, :id)
    end
end
