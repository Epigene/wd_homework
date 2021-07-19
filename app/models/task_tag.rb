# frozen_string_literal: true

class TaskTag < ApplicationRecord
  # A tie model between tasks and their tags

  belongs_to :task
  belongs_to :tag
end

# == Schema Information
#
# Table name: task_tags
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  task_id    :integer
#  tag_id     :integer
#
# Indexes
#
#  index_task_tags_on_tag_id   (tag_id)
#  index_task_tags_on_task_id  (task_id)
#
