class UsersController < ApplicationController
   before_action :user_is_logged_in?
    def index
      @data = Mobility.group(:dateTime).count

      respond_to do |format|
        format.html
    end
  
    def show
      @user = User.find_by(uid: params[:uid])
    end

    def get_events
      # url = "http://127.0.0.1:8000/request?"+"user_id=test_user&"+"datatype=com.personicle.individual.datastreams.heartrate&startTime=2022-02-28T16:50:11.226854&endTime=2022-02-28T16:50:11.226990"
      url = "http://127.0.0.1:8000/request/events?&user_id=jorindo.kgp@gmail.com&startTime=2021-12-09T08:26:00.000000&endTime=2021-12-09T15:42:00.000000"
      @response = RestClient.get(url,headers={Authorization: "Bearer #{session[:oktastate]['credentials']['token']} "})
      
    end

  end
  