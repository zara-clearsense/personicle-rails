class Physician < ApplicationRecord
    self.primary_key = 'user_id'
    validates_uniqueness_of :user_id
    has_many :physician_users, foreign_key: 'physician_user_id'
    has_many :users, through: :physician_users, foreign_key: 'physician_user_id'
end
