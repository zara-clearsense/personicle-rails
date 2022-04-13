class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :logged_in?, :require_user, :session_active?
  
  def user_is_logged_in?
    if !session[:oktastate]
      # redirect_to user_oktaoauth_omniauth_authorize_path
      root_path
    end
  end

  def session_active?
    if session[:oktastate]
      access_token = session[:oktastate]['credentials']['token']
      puts ENV['TOKEN_INTROSPECTION']
      url = ENV['TOKEN_INTROSPECTION']+"?token="+access_token
      
      res = RestClient::Request.execute(:url => url, headers: {Authorization: "Basic #{ENV['BASE_64_CLIENT']}", :content_type =>'application/x-www-form-urlencoded'}, :method => :post)
      is_active =  JSON.parse(res)
      if !is_active
        flash[:danger] = "Your session has expired. Please login again"
        redirect_to root_path
      end
    end
  end


  def logged_in?
    !session[:oktastate].nil?
  end

  def require_user
    if !logged_in? 
        flash[:danger] = "You must be logged in to perform that action"
        redirect_to root_path
    end
  end

  def after_sign_in_path_for(resource)
    resource.env['omniauth.origin'] || root_path
  end
end
