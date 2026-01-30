# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.references :mission, null: false, foreign_key: true
      t.string :description
      t.string :skill_name
      t.string :status
      t.text :completion_proof
      t.datetime :started_at
      t.datetime :completed_at
      t.integer :position

      t.timestamps
    end
  end
end
