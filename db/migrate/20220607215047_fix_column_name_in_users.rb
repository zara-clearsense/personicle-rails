class FixColumnNameInUsers < ActiveRecord::Migration[6.0]
  def self.up
    rename_column :users, :uid, :user_id
  end
end
