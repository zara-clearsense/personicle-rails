#require_relative 'application_controller'

class DashboardController < ApplicationController
  require 'json'
  require 'ostruct'
  require 'date'
  require 'time'
  before_action :require_user
  
  def index
    #@dashboards = dashboard

    logger.info "heyyyyyy"
    # puts session[:oktastate]['credentials']['token']
    three_months_ago = 3.months.ago.strftime("%Y-%m-%d %H:%M:%S.%6N")
    current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")
    # url = ENV['EVENTS_ENDPOINT']+"?user_id="+"#{session[:oktastate]["uid"]}"+"&startTime="+three_months_ago+"&endTime="+current_time

    url = 'http://localhost:3000/stepsCopy.json'
    logger.info 'url: ' + url
    res = RestClient::Request.execute(:url => url, headers: {Authorization: "Bearer #{session[:oktastate]['credentials']['token']} "}, :method => :get, :verify_ssl => false)
    
  ##
  #"name": "2019-11-01 00:00:00",
  #"createdAt": "2019-11-01 00:00:00",
  #"data": {"2019-11-01 00:00:00": 0}

## Procedure 
  # dateTime = Time.new(2020,11,24,1,2,3)
  # dateTime = "2020-11-24 01:02:03"
  # dateTime = dateTime.to_datetime
  # m = dateTime.strftime("%Y, %m, %d, %H, %M, %S, %z")
  # m = m.split(",")
  # puts m
  # year = m[0].to_i
  # month = m[1].to_i
  # day = m[2].to_i
  # hour = m[3].to_i
  # minute = m[4].to_i
  # second = m[5].to_i
  # hi = Time.new(year,month,day,hour,minute,second)
  # p hi
    if res
      response = JSON.parse(res)
      #{"dateTime": "2019-11-01 00:00:00", "value": "0"}
      @dashboards =[]
      response.each do |r|
        hours = r['dateTime'].to_datetime.strftime("%Y, %m, %d, %H, %M, %S, %z").split(",")[3].to_i
        minutes = r['dateTime'].to_datetime.strftime("%Y, %m, %d, %H, %M, %S, %z").split(",")[4].to_i
        #puts "The Date Time is: " + r['dateTime'] + ", hour in minutes is: " + (r['dateTime'].to_datetime.strftime("%Y, %m, %d, %H, %M, %S, %z").split(",")[3].to_i * 60).to_s + ", minutes is: " + r['dateTime'].to_datetime.strftime("%Y, %m, %d, %H, %M, %S, %z").split(",")[4].to_s
        minuteOfDay =  hours * 60 + minutes
        #puts minuteOfDay
        #puts r['dateTime'] =>  r['value']
        temp_obj = {"createdAt" => r['dateTime'], "name" => r['dateTime'], "minuteOfDay" => minuteOfDay, "data" => r['value'] }
        @dashboards << temp_obj
      end
      #puts @dashboards.each { |d| d['createdAt']}

      puts "======= th12244e response #{@dashboards}"
      @dashboards = @dashboards.group_by_day { |u| u['createdAt']}.to_h { |k, v| [k, v.size]}
      #@dashboards = @dashboards.group_by_minute { |u| u['createdAt']}.to_h { |k, v| [k, v.size] }
 
      #@dashboards = @dashboards.group_by_minute {|u| u['createdAt']}.to_h { |createdAt, data| [createdAt, data.size] }
      # puts "======= the response #{@dashboards}"
    end

    respond_to do |format|
      format.html
    end

     # logger.info 'response: ' + "#{@dashboards[0]}"
     # logger.info 'response : ' + "#{@dashboards.join("', '")}"

  end

  
end
