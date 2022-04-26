class ConnectionController < ApplicationController
  
    before_action :require_user, :session_active?
    
    def index
   
    end
  end
  