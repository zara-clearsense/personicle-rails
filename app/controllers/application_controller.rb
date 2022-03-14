class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :logged_in?, :require_user
  
  def user_is_logged_in?
    if !session[:oktastate]
      # redirect_to user_oktaoauth_omniauth_authorize_path
      root_path
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
