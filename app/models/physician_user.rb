class PhysicianUser < ApplicationRecord
    belongs_to :user, optional: true, primary_key: 'user_id'
    belongs_to :physician, optional: true, primary_key: 'user_id'
end
