# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table(:tasks) do |t|
      t.timestamps
      t.string(:title)
    end
  end
end
