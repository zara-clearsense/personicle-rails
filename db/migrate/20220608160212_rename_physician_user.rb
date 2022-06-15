class RenamePhysicianUser < ActiveRecord::Migration[6.0]
  def change
    rename_column :physician_users, :user_id, :user_user_id
    rename_column :physician_users, :physician_id, :physician_user_id

  end
end
