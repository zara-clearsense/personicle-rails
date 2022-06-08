class FixColumnNameInPhysicianUser < ActiveRecord::Migration[6.0]
  def self.up
    rename_column :physician_users, :patient_id, :user_id
  end
end
