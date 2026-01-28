class CreateMissions < ActiveRecord::Migration[8.1]
  def change
    create_table :missions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :domain, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.integer :target_level
      t.string :status
      t.boolean :ai_generated
      t.datetime :completed_at

      t.timestamps
    end
  end
end
