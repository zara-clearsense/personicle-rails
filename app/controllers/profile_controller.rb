class ProfileController < ApplicationController
  before_action :require_user, :session_active?
    
    def index
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
    end
  end
  