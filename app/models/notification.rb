class Notification < ApplicationRecord
  include Noticed::Model
  belongs_to :recipient, polymorphic: true, optional: true, class_name: "User"
end
