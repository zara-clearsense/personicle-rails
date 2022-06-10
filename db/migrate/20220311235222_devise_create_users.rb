# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
         
      t.string "email", default: "", null: false
      t.string "encrypted_password", default: "", null: false
      t.string "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.string "provider"
      t.string :name
      t.string :user_id, null: false
      t.boolean :is_physician, null: false, default: false
      t.index ["email"], name: "index_users_on_email", unique: true
      t.index ["provider"], name: "index_users_on_provider"
      t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
      t.index ["user_id"], name: "index_users_on_user_id"
    #   ## Database authenticatable
    #   t.string :email,              null: false, default: ""
    #   t.string :encrypted_password, null: false, default: ""

    #   ## Recoverable
    #   t.string   :reset_password_token
    #   t.datetime :reset_password_sent_at

    #   ## Rememberable
    #   t.datetime :remember_created_at

    #   ## Trackable
    #   # t.integer  :sign_in_count, default: 0, null: false
    #   # t.datetime :current_sign_in_at
    #   # t.datetime :last_sign_in_at
    #   # t.string   :current_sign_in_ip
    #   # t.string   :last_sign_in_ip

    #   ## Confirmable
    #   # t.string   :confirmation_token
    #   # t.datetime :confirmed_at
    #   # t.datetime :confirmation_sent_at
    #   # t.string   :unconfirmed_email # Only if using reconfirmable

    #   ## Lockable
    #   # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
    #   # t.string   :unlock_token # Only if unlock strategy is :email or :both
    #   # t.datetime :locked_at


    #   t.timestamps null: false
    # end

    # add_index :users, :email,                unique: true
    # add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
end