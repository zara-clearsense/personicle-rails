class CreatePhysiciansUsersTable < ActiveRecord::Migration[6.0]
  def change
    create_table :physician_users do |t|
      t.string :patient_id
      t.string :physician_id
      t.timestamps
    end
  end
end
