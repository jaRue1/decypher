class CreateUserDomains < ActiveRecord::Migration[8.1]
  def change
    create_table :user_domains do |t|
      t.references :user, null: false, foreign_key: true
      t.references :domain, null: false, foreign_key: true
      t.integer :level
      t.boolean :setup_completed
      t.jsonb :quiz_responses
      t.text :ai_assessment

      t.timestamps
    end
  end
end
