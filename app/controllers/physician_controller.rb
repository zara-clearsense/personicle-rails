class PhysicianController < ApplicationController
    before_action :require_user, :session_active?, :is_user_physician?, except: [:create_account]
    
    def index

    end

    def create_account
    end

    def is_user_physician?
        if !session[:oktastate]["physician"]
            return redirect_to pages_dashboard_path
        end
    end
end