class DashboardController < ApplicationController
  require 'json'
  require 'ostruct'
  require 'date'
  before_action :require_user
  
  def index
   
    three_months_ago = 3.months.ago.strftime("%Y-%m-%d %H:%M:%S.%6N")
    current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")
    
      # url = "http://127.0.0.1:8000/request?"+"user_id=test_user&"+"datatype=com.personicle.individual.datastreams.heartrate&startTime=2022-02-28T16:50:11.226854&endTime=2022-02-28T16:50:11.226990"
    # url = "http://127.0.0.1:8000/request/events?&individual_id=jorindo.kgp@gmail.com&startTime=2021-12-09 08:26:00.000000&endTime=2021-12-09 15:42:00.000000"
    url2 = "https://20.121.8.101:3000/request/events?&user_id=00u3w69sw5zLDtlYK5d7&startTime=2021-12-14 10:08:42.588000&endTime=2022-03-14 17:08:42.600000" 
    # url = "https://20.121.8.101:3000/request/events?&user_id="+"#{session[:oktastate]["uid"]}"+"&startTime="+three_months_ago+"&endTime="+current_time
    
    res = RestClient::Request.execute(:url => url2, headers: {Authorization: "Bearer #{session[:oktastate]['credentials']['token']} "}, :method => :get, :verify_ssl => false)
    if res
      @response = JSON.parse(res,object_class: OpenStruct)
    end
    
  end
  

end
