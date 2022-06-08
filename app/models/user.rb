class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable
  self.primary_key = 'user_id'
  validates_uniqueness_of :user_id
  has_many :physician_users,foreign_key: 'user_user_id'
  has_many :physicians, :through => :physician_users, foreign_key: 'user_user_id'

  devise :omniauthable, omniauth_providers: [:oktaoauth, :google_oauth2]

  def self.from_omniauth(auth)
    User.find_or_create_by(email: auth["info"]["email"]) do |user|
      user.provider = auth['provider']
      user.user_id = auth['uid']
      user.email = auth['info']['email']
      user.name = auth['info']['name']
    end

  end
end
