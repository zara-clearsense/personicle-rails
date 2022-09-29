# To deliver this notification:
#
# InsightNotification.with(post: @post).deliver_later(current_user)
# InsightNotification.with(post: @post).deliver(current_user)

class InsightNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.
  #
  def message
    t(".message")
  end
  #
  def url(id,life_aspect)
    if life_aspect == "sleep"
      pages_sleep_path(:noti_id => id)
    elsif life_aspect == "exposome"
      pages_exposome_path(:noti_id => id)
    elsif life_aspect == "mobility"
      pages_mobility_path(:noti_id => id)
    else
      pages_dashboard_path(:noti_id => id)
    end
  end
  
end
