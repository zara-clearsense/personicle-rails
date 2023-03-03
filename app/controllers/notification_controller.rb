class NotificationController < ApplicationController
    before_action :require_user, :session_active?, :get_user_notifications

    def index
        @current_user = User.find_by(user_id: session[:oktastate]['uid'])
        @notifications = @current_user.notifications.unread.newest_first
        @notifications.each do |n|
            # logger.info n.params

            # logger.info json_unescape(n.params)
        end
    end

    def mark_notification_as_read
       @notification_read = Notification.find_by(id: params[:notif_id]).mark_as_read!
       render json: {success: true}
    end 
end

class UserNotification
    def self.get_notifications(uid)
        @current_user = User.find_by(user_id: uid)
        @notifications = @current_user.notifications
        return @notifications
    end
end