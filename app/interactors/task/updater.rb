# frozen_string_literal: true

# Tag record change operation
class Task::Updater
  include ServiceApi

  PERMITTED_KEYS = Task::Creator::PERMITTED_KEYS

  # initializer
  def initialize(params:)
    @id = params[:id]
    @params = params.except(:id)
  end

  # @return [Hash]
  #  OK: {success: true, task: Task}
  #  NotFound: {success: false, task: nil}
  #  Errors: {success: false, task: Task(with errors)}
  def call
    return {success: false, task: nil} if task.blank?

    ActiveRecord::Base.transaction do
      success = task.update(@params.slice(*PERMITTED_KEYS))

      return {success: false, task: task} unless success

      update_tags!
    end

    {success: true, task: task.reload}
  end

  private

    def task
      return @task if defined?(@task)

      @task = Task.find_by(id: @id)
    end

    # update of tags is tricky in that it can produce three groups of changes:
    #  1. tags being removed (exist on record, but not in params)
    #  2. tags unchanged (exist both on record and in params)
    #  3. tags being added (do not exiust on record but are passed in params)
    def update_tags!
      return unless @params.key?(:tags)

      tags_to_remove.each do |tag_title|
        TaskTag.where(task: task).joins(:tag).merge(Tag.where(title: tag_title)).destroy_all
      end

      tags_to_add.each do |tag_title|
        TaskTag.where(task: task, tag: tag_from_title(tag_title)).first_or_create!
      end
    end

    def tags_on_record
      @tags_on_record ||= task.tags.pluck(:title).to_set
    end

    def tags_in_params
      @tags_in_params ||= Array.wrap(@params[:tags]).to_set
    end

    def tags_to_remove
      tags_on_record - tags_in_params
    end

    def tags_to_add
      tags_in_params - tags_on_record
    end

    def tag_from_title(title)
      Tag.find_by(title: title) ||
        Tag::Creator.call(params: {title: title})[:tag]
    end
end
