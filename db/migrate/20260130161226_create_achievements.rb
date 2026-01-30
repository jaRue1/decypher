class CreateAchievements < ActiveRecord::Migration[8.1]
  def change
    create_table :achievements do |t|
      t.references :user, null: false, foreign_key: true
      t.string :achievement_type, null: false
      t.references :achievable, polymorphic: true
      t.jsonb :metadata, default: {}
      t.datetime :achieved_at

      t.timestamps
    end

    add_index :achievements, [:user_id, :achievement_type, :achievable_type, :achievable_id],
              name: "index_achievements_uniqueness", unique: true
  end
end
