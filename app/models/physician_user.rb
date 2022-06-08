class PhysicianUser < ApplicationRecord
    validates :physician, uniqueness: { scope: :user } # dont add to join table if already exits
    belongs_to :user, optional: true, primary_key: 'user_id', foreign_key: 'user_user_id'
    belongs_to :physician, optional: true, primary_key: 'user_id', foreign_key: 'physician_user_id'
end
