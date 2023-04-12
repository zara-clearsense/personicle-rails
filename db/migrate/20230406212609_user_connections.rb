class UserConnections < ActiveRecord::Migration[6.0]
  def change
    create_table :connections do |t|
      t.string :id
      t.string :userId
      t.string :service
      t.string :access_token
      t.string :external_user_id
      t.string :refresh_token
      t.datetime :last_accessed_at
      t.string :scope
      t.string :status
  end
end
