class DashboardController < ApplicationController
  require 'json'
  require 'ostruct'
  require 'date'
  before_action :require_user
  
  def index
   
    three_months_ago = 3.months.ago.strftime("%Y-%m-%d %H:%M:%S.%6N")
    current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")
    
    puts session[:oktastate]['credentials']['token']
    url = "https://20.121.8.101:3000/request/events?&user_id="+"#{session[:oktastate]["uid"]}"+"&startTime="+three_months_ago+"&endTime="+current_time
    
    res = RestClient::Request.execute(:url => url, headers: {Authorization: "Bearer #{session[:oktastate]['credentials']['token']} "}, :method => :get, :verify_ssl => false)
    if res
      @response = JSON.parse(res,object_class: OpenStruct)
    end
    
  end
  

end
