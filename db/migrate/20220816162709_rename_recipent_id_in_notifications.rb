class RenameRecipentIdInNotifications < ActiveRecord::Migration[6.0]
  
    def self.up
      rename_column :notifications, :recipient_user_id, :recipient_id
      change_column :notifications, :recipient_id, :string
    end
  
end
