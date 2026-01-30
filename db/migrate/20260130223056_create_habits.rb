# frozen_string_literal: true

class CreateHabits < ActiveRecord::Migration[8.1]
  def change
    create_table :habits do |t|
      t.references :user, null: false, foreign_key: true
      t.references :domain, foreign_key: true
      t.string :name, null: false
      t.string :icon
      t.string :color
      t.integer :target_days_per_week, default: 7
      t.integer :target_days_per_month, default: 30
      t.boolean :active, default: true
      t.integer :position

      t.timestamps
    end

    add_index :habits, %i[user_id active]
    add_index :habits, %i[user_id position]
  end
end
