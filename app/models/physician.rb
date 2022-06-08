class Physician < ApplicationRecord
    validates_uniqueness_of :user_id
    has_many :physician_users, primary_key: 'user_id'
    has_many :users, through: :physician_users
end
