class AddAddressToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :address, :string, default: ''
    add_column :users, :city, :string, default: ''
    add_column :users, :country, :string, default: ''
    add_column :users, :postal_code, :string, default: ''
  end
end
