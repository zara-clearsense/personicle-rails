class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :logged_in?, :require_user, :session_active?, :is_physician?
  
  def user_is_logged_in?
    if !session[:oktastate]
      # redirect_to user_oktaoauth_omniauth_authorize_path
      root_path
    end
  end

  def is_physician?
    url = "https://dev-01936861.okta.com/api/v1/users/#{session[:oktastate]['uid']}/groups"
    res = JSON.parse(RestClient::Request.execute(:url => url, headers: {Authorization: ENV['GET_USER_GROUP_TOKEN']}, :method => :get ))
      
      for r in res
        if r['id'] == ENV['PHYSICIAN_GROUP_ID']
          session[:oktastate][:physician] = true
          return true
        end
      end
    return false

  end
  # def login_type_physician?
  #   # puts "hello"
  #   # puts session[:oktastate]
  #   # puts session[:oktastate]["physician"]
  #   if !session[:oktastate]["physician"]
  #     flash[:danger] = "You do not have access to physician dashboard"
  #     redirect_to pages_dashboard_path
  #   end
  # end

  # def login_type_user?
  #   if session[:oktastate]["physician"]
  #     flash[:danger] = "You do not have access to user dashboard"
  #     redirect_to pages_dashboard_physician_path
  #   end
  # end

  def session_active?
    if session[:oktastate]
      access_token = session[:oktastate]['credentials']['token']

      url = ENV['TOKEN_INTROSPECTION']+"?token="+access_token
      
      res = RestClient::Request.execute(:url => url, headers: {Authorization: "Basic #{ENV['BASE_64_CLIENT']}", :content_type =>'application/x-www-form-urlencoded'}, :method => :post)
      is_active =  JSON.parse(res)['active']
      
      if !is_active
        flash[:danger] = "Your session has expired. Please login again"
        redirect_to root_path
      end
    end
  end

  def hard_refresh?
    
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
