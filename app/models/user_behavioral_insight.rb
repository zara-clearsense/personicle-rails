class UserBehavioralInsight < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  after_create_commit :notify_recipient

  private
  def notify_recipient
    InsightNotification.with(message: self).deliver_later(recipient)
  end
end