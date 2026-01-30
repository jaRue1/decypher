# frozen_string_literal: true

class CreateDomains < ActiveRecord::Migration[8.1]
  def change
    create_table :domains do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.string :icon
      t.jsonb :level_titles
      t.json :quiz_questions

      t.timestamps
    end
    add_index :domains, :slug, unique: true
  end
end
