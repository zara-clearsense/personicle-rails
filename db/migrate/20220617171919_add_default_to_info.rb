class AddDefaultToInfo < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :info, :json, default: {}
  end
end
