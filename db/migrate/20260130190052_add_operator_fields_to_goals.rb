# frozen_string_literal: true

class AddOperatorFieldsToGoals < ActiveRecord::Migration[8.1]
  def change
    add_column :goals, :priority, :integer
    add_column :goals, :context, :text
    add_column :goals, :success_criteria, :text
    add_column :goals, :current_blockers, :text
  end
end
