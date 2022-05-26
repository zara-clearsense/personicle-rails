class DashboardController < ApplicationController
  require 'json'
  require 'ostruct'
  require 'date'
  before_action :require_user, :session_active?
  # Load all events data
  # Find average sleep duration for last week + last month
  # def get_events
  
  #   Rails.cache.fetch([:events,session[:oktastate]['uid']], expires_in: 20.minutes) do
  #     three_months_ago = 3.months.ago.strftime("%Y-%m-%d %H:%M:%S.%6N")
  #     current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")
  #     url = ENV['EVENTS_ENDPOINT']+"?startTime="+three_months_ago+"&endTime="+current_time
  #     JSON.parse(RestClient::Request.execute(:url => url, headers: {Authorization: "Bearer #{session[:oktastate]['credentials']['token']} "}, :method => :get,:verify_ssl => false ),object_class: OpenStruct)
  #    end
  # end

  def index
    # puts session[:oktastate]['credentials']['token']
    if params[:refresh]=="hard_refresh"
      puts "hard refresh"
      @response = FetchData.get_events(session,event_type=false,hard_refresh=true)
    else
      puts "not hard refresh"
      @response = FetchData.get_events(session,event_type=false,hard_refresh=false)
    end 
    
    if !@response.empty?
      # @response = JSON.parse(res,object_class: OpenStruct)
      # last_month_total_sleep, last_month_sleep_events
      # last_week_total_sleep, last_week_sleep_events
      
      @sleep_events = @response.select {|event| event['event_name'] == 'Sleep'}
      # duration is in milliseconds in the data packet
      @last_month_total_sleep = @sleep_events.select {|event| event['start_time'].to_datetime > 30.days.ago}.sum {|event| event['parameters']['duration']}/(60*1000)
      @last_month_sleep_event = @sleep_events.select {|event| event['start_time'].to_datetime > 30.days.ago}.size
      @last_week_total_sleep = @sleep_events.select {|event| event['start_time'].to_datetime > 7.days.ago}.sum {|event| event['parameters']['duration']}/(60*1000)
      @last_week_sleep_event = @sleep_events.select {|event| event['start_time'].to_datetime > 7.days.ago}.size
      
      @last_week_average_sleep = @last_week_sleep_event>0? @last_week_total_sleep/@last_week_sleep_event:0
      @last_month_average_sleep = @last_month_sleep_event>0? @last_month_total_sleep/@last_month_sleep_event:0
      
    end
    
  end
  

end
