class FixColumnNameInPhysicians < ActiveRecord::Migration[6.0]
  def self.up
    rename_column :physicians, :physician_id, :user_id
  end
end
