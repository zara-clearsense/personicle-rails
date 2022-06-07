class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  

    def oktaoauth
      # puts request.env["omniauth.params"]["login_type"]
      # if request.env["omniauth.params"]["login_type"] == "physician"
      #   # @physician = Physician.from_omniauth(request.env["omniauth.auth"].except("extra") )
        
      #     # puts "here"
      #     # puts @physician
      #     # user tried physician login, but is not a physician
      #     if is_physician() == false 
      #       puts "here"
      #       return redirect_to ENV['OKTA_URL']+"/login/signout?fromURI=http://localhost:3000/logout", physician: false
      #     else
      #       @physician = Physician.from_omniauth(request.env["omniauth.auth"].except("extra") )
      #     end
      # else
      #   if is_physician() == true # physician tried to log in as user
      #     return  redirect_to ENV['OKTA_URL']+"/login/signout?fromURI=http://localhost:3000/logout"
      #   else
      #     @user = User.from_omniauth(request.env["omniauth.auth"].except("extra") )
      #   end
        
      # end

      # if !@user.nil? and @user.save
      #   session[:oktastate] = request.env["omniauth.auth"].except("extra")
      # elsif !@physician.nil? and @physician.save
      #   session[:oktastate] = request.env["omniauth.auth"].except("extra")
      #   session[:oktastate][:physician] = true
      # else
      #   print(@user.errors.full_messages)
      # end
  
      # if @user.present?
      #   redirect_to pages_dashboard_path
      # elsif @physician.present?
      #   redirect_to pages_dashboard_physician_path
      # end
      puts request.env["omniauth.auth"]
      @user = User.from_omniauth(request.env["omniauth.auth"].except("extra") )
      
      if @user.save
        session[:oktastate] = request.env["omniauth.auth"].except("extra")
        
      else
        print(@user.errors.full_messages)
      end

      if @user.present?
        if is_physician?
          puts "user is physician"
          @user.is_physician = true
          @user.save
          return redirect_to pages_dashboard_physician_path
        end
        redirect_to pages_dashboard_path
      end
    end
    

  
    def failure
     
    end
    # def oktaoauth_physician
    #   @user = User.from_omniauth(request.env["omniauth.auth"].except("extra") )
      
    #   if @user.save
    #     session[:oktastate] = request.env["omniauth.auth"].except("extra")
        
    #   else
    #     print(@user.errors.full_messages)
    #   end

    #   if @user.present?
    #     # redirect_to user_path(session[:oktastate][:uid])
    #     redirect_to pages_dashboard_path
    #   end
    # end
    
    def google_oauth2
      @user = User.from_omniauth(request.env["omniauth.auth"].except("extra") )
      
      if @user.save
        session[:oktastate] = request.env["omniauth.auth"].except("extra")
        
      else
        print(@user.errors.full_messages)
      end

      if @user.present?
        url = "https://dev-01936861.okta.com/api/v1/users/#{session[:oktastate]['uid']}"
        res = JSON.parse(RestClient::Request.execute(:url => url, headers: {Authorization: "SSWS 00JRLUd-fyWojjhDad1Ask3S3DssMHR2T2nAOg1ogk"}, :method => :get ))
        puts res["profile"]["physi"]
        # redirect_to user_path(session[:oktastate][:uid])
        redirect_to pages_dashboard_path
      end
      end
  end
  