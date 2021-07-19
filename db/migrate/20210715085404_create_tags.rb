# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table(:tags) do |t|
      t.timestamps
      t.string(:title)
    end

    add_index(:tags, :title, unique: true)
  end
end
