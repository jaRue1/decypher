# frozen_string_literal: true

class CreateBadges < ActiveRecord::Migration[8.1]
  def change
    create_table :badges do |t|
      t.references :mission, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.string :icon

      t.timestamps
    end
  end
end
