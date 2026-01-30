# frozen_string_literal: true

class AddProgressionFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :total_xp, :integer, default: 0, null: false
  end
end
