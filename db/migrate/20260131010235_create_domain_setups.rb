# frozen_string_literal: true

class CreateDomainSetups < ActiveRecord::Migration[8.1]
  def change
    create_table :domain_setups do |t|
      t.references :user, null: false, foreign_key: true
      t.references :domain, null: false, foreign_key: true
      t.string :step, default: 'goals' # goals, background, preview, completed
      t.text :goals_input
      t.text :blockers_input
      t.text :success_input
      t.text :background_input
      t.jsonb :generated_plan, default: {}
      t.timestamps

      t.index %i[user_id domain_id], unique: true
    end
  end
end
