class DashboardController < ApplicationController
  require 'json'
  require 'ostruct'
  require 'date'
  before_action :require_user, :session_active?


  def index
    puts session[:oktastate]['credentials']['token']
    
    st = 3.months.ago.strftime("%Y-%m-%d %H:%M:%S.%6N")
    et = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")

    if params[:refresh]=="hard_refresh"
      puts "hard refresh"
      @response = FetchData.get_events(session,event_type=false,st,et,hard_refresh=true, uid=session[:oktastate]['uid'])
      @response_step = FetchData.get_datastreams(session,source="google-fit",data_type="com.personicle.individual.datastreams.step.count",start_date=st, end_date=et, hard_refresh=true,uid=session[:oktastate]['uid'])
    else
      puts "not hard refresh"
      @response = FetchData.get_events(session,event_type=false,st,et,hard_refresh=false, uid=session[:oktastate]['uid'])
      @response_step = FetchData.get_datastreams(session,source="google-fit",data_type="com.personicle.individual.datastreams.step.count",start_date=st, end_date=et, hard_refresh=false,uid=session[:oktastate]['uid'])
    end 

    # @is_physician = session["physician"] 
    # puts @is_physician
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

    if !@response_step.empty?
    
      tmp_steps = @response_step.select {|record| record['timestamp'].to_datetime > 30.days.ago}.map {|rec| [rec['timestamp'].to_date, rec['value']]}.group_by {|r| r[0]}.to_h
      @daily_steps = tmp_steps.map {|k,v| [k, v.sum {|r| r[1]}]}.to_h
      # puts @daily_steps

      @last_month_total_steps = @daily_steps.select {|k,v| k > 30.days.ago}.sum {|k,v| v}
      @last_month_steps_days = @daily_steps.select {|k,v| k > 30.days.ago}.size
      @last_week_total_steps = @daily_steps.select {|k,v| k > 7.days.ago}.sum {|k,v| v}
      @last_week_steps_days = @daily_steps.select {|k,v| k > 7.days.ago}.size

      @last_week_average_steps = @last_week_steps_days>0? @last_week_total_steps/@last_week_steps_days:0
      @last_month_average_steps = @last_month_steps_days>0? @last_month_total_steps/@last_month_steps_days:0
    end
    
  end
  

end
