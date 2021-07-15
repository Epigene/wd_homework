# frozen_string_literal: true

class CreateTaskTags < ActiveRecord::Migration[6.0]
  def change
    create_table(:task_tags) do |t|
      t.timestamps
      t.references(:task)
      t.references(:tag)
    end
  end
end
