# frozen_string_literal: true

class TaskTag < ApplicationRecord
  # A tie model between tasks and their tags

  belongs_to :task
  belongs_to :tag
end
