class HomeController < ApplicationController
    before_action :user_is_logged_in?, :session_active?, :get_user_notifications

    def index
      # redirect_to root_path if !user_is_logged_in?
    end
  end
  