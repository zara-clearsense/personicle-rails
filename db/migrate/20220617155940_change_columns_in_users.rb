class ChangeColumnsInUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :address
    remove_column :users, :city
    remove_column :users, :country
    remove_column :users, :postal_code
    add_column :users, :info, :json
  end
end
