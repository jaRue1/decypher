class RenameTasks < ActiveRecord::Migration[8.1]
  def change
    rename_table :tasks, :objectives
    rename_column :skills, :task_id, :objective_id
  end
end
