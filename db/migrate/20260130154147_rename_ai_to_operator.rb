class RenameAiToOperator < ActiveRecord::Migration[8.1]
  def change
    rename_column :missions, :ai_generated, :operator_generated
    rename_column :user_domains, :ai_assessment, :operator_assessment
  end
end
