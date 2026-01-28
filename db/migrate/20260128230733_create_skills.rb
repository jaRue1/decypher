class CreateSkills < ActiveRecord::Migration[8.1]
  def change
    create_table :skills do |t|
      t.references :user, null: false, foreign_key: true
      t.references :domain, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.string :name
      t.datetime :acquired_at

      t.timestamps
    end
  end
end
