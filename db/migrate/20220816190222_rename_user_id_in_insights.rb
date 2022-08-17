class RenameUserIdInInsights < ActiveRecord::Migration[6.0]
  def self.up
    rename_column :user_behavioral_insights, :user_id, :recipient_id
  end
end
