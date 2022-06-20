class ProfileController < ApplicationController
  before_action :require_user, :session_active?
    def remove_physician
      if not params[:remove_physicians].blank? and !session[:oktastate]["physician"]
        @user = User.find_by(user_id: session[:oktastate]["uid"])
        params[:remove_physicians].each do |phy|
          @phy = Physician.find_by(user_id: phy)
          @user.physicians.destroy(@phy)
        end
        flash[:warning] = "Successfully removed physicians"
        redirect_to pages_profile_path
      end
    end

    def add_physician
      puts "hello"
      if not params[:physicians].blank? and !session[:oktastate]["physician"]
        @user = User.find_by(user_id: session[:oktastate]["uid"])
        
        params[:physicians].each do |phy|
          @phy = Physician.find_by(user_id: phy)
          puts"hello"
          @user.physicians << @phy
        end
        flash[:success] = "Successfully added physicians"
        redirect_to pages_profile_path
      end

    end

    def update_user_info
      puts params.except(:authenticity_token, :action, :controller)
      @user = User.find_by(user_id: session[:oktastate]['uid'])
      payload = {}
      params.except(:authenticity_token, :action, :controller).each do |k,v|
        if !v.blank?
          payload[k] =  v
        end
      end
      puts "hello"
      puts payload
      payload.each do |k,v|
        @user.info[k] = v
      end
      @user.save
      return redirect_to pages_profile_path
    end

    def index
      
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
  