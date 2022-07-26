class SessionsController < ApplicationController
    def new
    end
  
    def create
    end
  
    def destroy
      session[:oktastate] = nil
      puts params
      if params[:physician] == false
        flash[:warning] = "Please sign in as personicle user"
      else
        flash[:info] = "You have logged out"
      end
      redirect_to root_path
      # return redirect_to ENV['OKTA_URL']+"/login/signout?formURI="+ request.base_url + "/logout"
      # redirect_to ENV['OKTA_URL'] + "/login/signout?fromURI=" + request.base_url + "/logout"
    end
  end
  