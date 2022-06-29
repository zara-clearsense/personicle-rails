class AddPhyQuesFieldToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :physician_users, :questions, :json, default: {}
   
  end
end
