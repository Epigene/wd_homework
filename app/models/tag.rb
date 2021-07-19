# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :task_tags, dependent: :destroy
  has_many :tasks, through: :task_tags

  validates :title, presence: true, uniqueness: true
end

# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  title      :string
#
# Indexes
#
#  index_tags_on_title  (title) UNIQUE
#
