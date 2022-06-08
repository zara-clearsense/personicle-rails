class FixColumnName < ActiveRecord::Migration[6.0]
  def self.up
    rename_column :physician_users, :user_id, :uid
  end

end
