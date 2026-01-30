class AddProgressionFieldsToMissions < ActiveRecord::Migration[8.1]
  def change
    add_column :missions, :grade, :string
    add_column :missions, :started_at, :datetime
    # completed_at already exists
  end
end
