# frozen_string_literal: true

class AddProgressionFieldsToObjectives < ActiveRecord::Migration[8.1]
  def change
    add_column :objectives, :difficulty, :integer, default: 1
    add_column :objectives, :xp_reward, :integer, default: 25
    # started_at, completed_at, status already exist
  end
end
