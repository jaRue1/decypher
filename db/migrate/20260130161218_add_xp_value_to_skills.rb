# frozen_string_literal: true

class AddXpValueToSkills < ActiveRecord::Migration[8.1]
  def change
    add_column :skills, :xp_value, :integer, default: 25
  end
end
