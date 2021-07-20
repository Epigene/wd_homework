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

      Array.wrap(@params[:tags]).each do |tag_title|
        tag =
          Tag.find_by(title: tag_title) ||
          Tag::Creator.call(params: {title: tag_title})[:tag]

        TaskTag.where(task: task, tag: tag).first_or_create!
      end
    end
end
