# frozen_string_literal: true

class AddPositionToDomains < ActiveRecord::Migration[8.1]
  def change
    add_column :domains, :position, :integer, default: 0, null: false
    add_index :domains, :position
  end
end
