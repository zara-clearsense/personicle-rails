class FixColumnNameInPhysician < ActiveRecord::Migration[6.0]
  def self.up
    rename_column :physicians, :user_id, :physician_id
  end
end
