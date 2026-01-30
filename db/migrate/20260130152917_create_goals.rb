class CreateGoals < ActiveRecord::Migration[8.1]
  def change
    create_table :goals do |t|
      t.references :user, null: false, foreign_key: true
      t.references :domain, null: true, foreign_key: true
      t.text :content
      t.string :goal_type
      t.string :timeframe
      t.string :status

      t.timestamps
    end
  end
end
