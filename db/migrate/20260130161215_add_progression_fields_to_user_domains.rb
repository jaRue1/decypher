class AddProgressionFieldsToUserDomains < ActiveRecord::Migration[8.1]
  def change
    add_column :user_domains, :xp, :integer, default: 0, null: false
    add_column :user_domains, :current_grade, :string, default: "D"
    add_column :user_domains, :level_started_at, :datetime
  end
end
