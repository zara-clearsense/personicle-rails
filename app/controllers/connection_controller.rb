class ConnectionController < ApplicationController
  
    before_action :require_user, :session_active?, :get_user_notifications
    
    def index
      
    end
  end
  