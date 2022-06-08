class CreateUserTable < ActiveRecord::Migration[6.0]
  def change
    create_table :users , :primary_key => :user_id do |t|
      t.string "email", default: "", null: false
      t.string "encrypted_password", default: "", null: false
      t.string "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.string "provider"
      t.string :name
      t.boolean :is_physician, null: false, default: false
      t.index ["email"], name: "index_users_on_email", unique: true
      t.index ["provider"], name: "index_users_on_provider"
      t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
      t.index ["user_id"], name: "index_users_on_user_id"
    end
  end
end
