class ProfileController < ApplicationController
  before_action :require_user, only: [:remove_physician, :add_physician,:update_user_info ,:index]
  before_action :session_active?, only: [:remove_physician, :add_physician,:update_user_info ,:index]
  before_action :get_user_notifications, only: [:remove_physician, :add_physician,:update_user_info ,:index]
  protect_from_forgery with: :null_session
  # before_action :require_user, :session_active?, :get_user_notifications
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

      payload.each do |k,v|
        @user.info[k] = v
      end
      @user.save
      return redirect_to pages_profile_path
    end


    # api endpoint to remove physicians from user
    def remove_physicinas_api
      begin
        res = JSON.parse(RestClient::Request.execute(:url => "https://api.personicle.org/auth/authenticate", headers: {Authorization: request.authorization}, :method => :get ),object_class: OpenStruct)
        @user = User.find_by(user_id: res['user_id'])
        params[:physicians].each do |phy|
          @phy = Physician.find_by(user_id: phy)
          @user.physicians.destroy(@phy)
        end
        render json: {message: 'Successfully removed physicians'}, status: 200
      rescue => exception
        if exception.response.code == 401
          return  render status: :unauthorized, json: { error: "Unauthorized. You are not authorized to access this resource." }
        end
      end
    end
    
    def get_users_physicians_api
      begin
        res = JSON.parse(RestClient::Request.execute(:url => "https://api.personicle.org/auth/authenticate", headers: {Authorization: request.authorization}, :method => :get ),object_class: OpenStruct)
        @user = User.find_by(user_id: res['user_id'])
        @phys = @user.physicians
      rescue => exception
        
      end
    end

    # api endpoint to add physicians for a user
    def add_physicians_api
      begin
        res = JSON.parse(RestClient::Request.execute(:url => "https://api.personicle.org/auth/authenticate", headers: {Authorization: request.authorization}, :method => :get ),object_class: OpenStruct)
        @user = User.find_by(user_id: res['user_id'])
        params[:physicians].each do |phy|
          @phy = Physician.find_by(user_id: phy)
          @user.physicians << @phy
        end
        render json: {message: 'Successfully added physicians'}, status: 200
      rescue => exception
        if exception.response.code == 401
          return  render status: :unauthorized, json: { error: "Unauthorized. You are not authorized to access this resource." }
        end
      end
    end

   # api endpoint  to update user info 
    def update_user
      begin
        res = JSON.parse(RestClient::Request.execute(:url => "https://api.personicle.org/auth/authenticate", headers: {Authorization: request.authorization}, :method => :get ),object_class: OpenStruct)
        @user = User.find_by(user_id: res['user_id'])
        payload = {}
        params.each do |k,v|
          if !v.blank?
            payload[k] =  v
          end
        end
  
        payload.each do |k,v|
          @user.info[k] = v
        end
        @user.save
        render json: {}, status: 200
      rescue => exception
        if exception.response.code == 401
            return  render status: :unauthorized, json: { error: "Unauthorized. You are not authorized to access this resource." }
        end
      end
    end

    def get_user
      begin
        res = JSON.parse(RestClient::Request.execute(:url => "https://api.personicle.org/auth/authenticate", headers: {Authorization: request.authorization}, :method => :get ),object_class: OpenStruct)
        @user = User.find_by(user_id: res['user_id'])
        return  render json: @user.to_json(), status: 200
      rescue => exception
        if exception.response.code == 401
          return  render status: :unauthorized, json: { error: "Unauthorized. You are not authorized to access this resource." }
        end
      end
    end

    def index
      
      # if session[:oktastate]["physician"] and not params[:users].blank?
      #   redirect_to "https://personicle-physician.herokuapp.com/?auth=#{session[:oktastate]['credentials']['token']}&patient_id=#{params[:users]}", :target => "_blank" 

      # end

      if not params[:delete_account].blank? and params[:delete_account] == "delete"
        url = ENV['ACCOUNT_DELETE']
       
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
        # get user profile image 
        image_key = @user.info['image_key']
        res = JSON.parse(RestClient::Request.execute(:url => "https://personicle-file-upload.herokuapp.com/user_images/#{image_key}?user_id=#{session[:oktastate]['uid']}", headers: {Authorization: "Bearer #{session[:oktastate]['credentials']['token']} "}, :method => :get,:verify_ssl => false ),object_class: OpenStruct)
        # puts res['image_url']
        @profile_image_url = res['image_url']
      else
        @physician = Physician.find_by(user_id: session[:oktastate]["uid"])
      end

    end
  end
  