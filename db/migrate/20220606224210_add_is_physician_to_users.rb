class AddIsPhysicianToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_physician, :boolean, null: false, default: false
  end
end
