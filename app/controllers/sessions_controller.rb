class SessionsController < ApplicationController
    def new
    end
  
    def create
    end
  
    def destroy
      session[:oktastate] = nil
      flash[:success] = "You have logged out"
      redirect_to root_path
      # redirect_to ENV['OKTA_URL'] + "/login/signout?fromURI=" + request.base_url + "/logout"
    end
  end
  