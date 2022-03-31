class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    
    def oktaoauth
      # user.rb
      @user = User.from_omniauth(request.env["omniauth.auth"].except("extra") )
      
      if @user.save
        session[:oktastate] = request.env["omniauth.auth"].except("extra")
        
      else
        print(@user.errors.full_messages)
      end
  
      if @user.present?
        # redirect_to user_path(session[:oktastate][:uid])
        redirect_to pages_dashboard_path
      end
    end
  
    def failure
     
    end
  end
  