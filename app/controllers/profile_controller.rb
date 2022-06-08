class ProfileController < ApplicationController
  before_action :require_user, :session_active?
    
    def index
      
      if not params[:physicians].blank? and !session[:oktastate]["physician"]
        @user = User.find_by(user_id: session[:oktastate]["uid"])
        params[:physicians].each do |phy|
          @phy = Physician.find_by(user_id: phy)
          @user.physicians << @phy
        end
      end

      if session[:oktastate]["physician"] and not params[:users].blank?
        redirect_to "https://personicle-physician.herokuapp.com/?auth=#{session[:oktastate]['credentials']['token']}&patient_id=#{params[:users]}", :target => "_blank" 

      end

      if not params[:delete_account].blank? and params[:delete_account] == "delete"
        url = ENV['ACCOUNT_DELETE']
        res = RestClient::Request.execute(:url => url, headers: {Authorization: "Bearer #{session[:oktastate]['credentials']['token']} "}, :method => :delete,:verify_ssl => false )
        print(res.code)
        print(res)
        if res.code == 200
          session[:oktastate] = nil
          flash[:warning] = "Your account is successfully deleted"
          redirect_to root_path
        end
      end

      if !session[:oktastate]["physician"]
        @user = User.find_by(user_id: session[:oktastate]["uid"])
      else
        @physician = Physician.find_by(user_id: session[:oktastate]["uid"])
      end

    end
  end
  