class MobilityController < ApplicationController
    require 'json'
    require 'ostruct'
    require 'date'
    before_action :require_user, :session_active?, :get_user_notifications

  def index
    # if !params[:noti_id].nil? &&  !params[:noti_id].blank? 
    #   @notification_read = Notification.find_by(id: params[:noti_id]).mark_as_read!
    # end
    # add another request for specific data streams (step count)
    # use exercise for another chart
    st = 3.months.ago.strftime("%Y-%m-%d %H:%M:%S.%6N")
    et = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")
    if params.has_key?(:refresh) && params[:refresh]=="hard_refresh"
      @response = FetchData.get_datastreams(session,source="google-fit",datatype="com.personicle.individual.datastreams.interval.step.count",start_date=st, end_date=et, hard_refresh=true,uid=session[:oktastate]['uid'])
      # puts "response"
      # puts @response
    else
      @response = FetchData.get_datastreams(session,source="google-fit",datatype="com.personicle.individual.datastreams.interval.step.count",start_date=st, end_date=et, hard_refresh=false,uid=session[:oktastate]['uid'])
      # puts "response"
      # puts @response
    end 
 

    if !@response.empty?

      @steps_data_raw = []
      @mobility_by_day= []
      @response.each { |record|
        timestamp_data = record['end_time'].to_datetime
        @steps_data_raw.push({'minute_value' => timestamp_data.minute + timestamp_data.hour * 60, 'weekday' => record['end_time'].to_datetime.strftime("%A"), 'value' => record['value']})
        # @mobility_by_day.push({'timestamp' => timestamp_data.to_date, 'value' => record['value']})
        # puts record['value'].class
        # puts timestamp_data, timestamp_data.class, timestamp_data.to_date.class, type(record['timestamp'])
      }
        # puts mobility_by_day
        
      temporary_steps = @response.group_by_day{|rec| rec['end_time'].to_datetime}.to_h
      @mobility_aggregated = temporary_steps.map {|k,v| [k, v.sum {|r| r['value']}]}.to_h
      # puts @mobility_aggregated

      weekly_steps = @response.group_by_week{|rec| rec['end_time'].to_datetime}.to_h
      @weekly_aggregated = weekly_steps.map {|k,v| [k, v.sum {|r| r['value']}]}
      # puts @weekly_aggregated

      all_minutes = [*0..1439]
      all_days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']

      weekday_grouped_data = @steps_data_raw.group_by { |rec| rec['weekday']}.to_h
      
      # puts weekday_grouped_data

      @processed_steps_data = {}
      all_days.each { |week_day|
        # puts week_day
        current_day_data = weekday_grouped_data[week_day]
        if !current_day_data.nil? 
          summarized_data = current_day_data.group_by {|rec| rec['minute_value']/30}.map {|k, v| [k, (v.size>0)?(v.sum {|r| r['value']}.to_f/90) : 0]}.to_h
          # summarized_data = current_day_data.group_by {|rec| rec[0]}.to_h {|k, v| [k, v.sum {|r| r[1]}]}
          @processed_steps_data[week_day] = summarized_data
        end
      }

      temporary_steps = @response.group_by_day{|rec| rec['end_time'].to_datetime}.to_h 
      @mobility_aggregated = temporary_steps.map {|k,v| {k => v.sum {|r| r['value']}}}
      # puts @mobility_aggregated

      # Find how many total steps were taken in the last week
      tmp_steps = @response.select {|record| record['end_time'].to_datetime > 30.days.ago}.map {|rec| [rec['end_time'].to_date, rec['value']]}.group_by {|r| r[0]}.to_h
      @daily_steps = tmp_steps.map {|k,v| [k, v.sum {|r| r[1]}]}.to_h
      # puts @daily_steps
      @last_week_total_steps = @daily_steps.select {|k,v| k > 7.days.ago}.sum {|k,v| v}
      puts "Number of Steps Taken All Last Week"
      puts @last_week_total_steps 
    else
      @processed_steps_data = {}
      @mobility_aggregated = {}
    end
  end

  def last_month
    st = 3.months.ago.strftime("%Y-%m-%d %H:%M:%S.%6N")
    et = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")
    if params.has_key?(:refresh) && params[:refresh]=="hard_refresh"
      @response = FetchData.get_datastreams(session,source="google-fit",datatype="com.personicle.individual.datastreams.interval.step.count",start_date=st, end_date=et, hard_refresh=true,uid=session[:oktastate]['uid'])
      # puts "response"
      # puts @response
    else
      @response = FetchData.get_datastreams(session,source="google-fit",datatype="com.personicle.individual.datastreams.interval.step.count",start_date=st, end_date=et, hard_refresh=false,uid=session[:oktastate]['uid'])
      # puts "response"
      # puts @response
    end 
  
    tmp_steps = @response.select {|record| record['end_time'].to_datetime > 30.days.ago}.map {|rec| [rec['end_time'].to_date, rec['value']]}.group_by {|r| r[0]}.to_h
    @daily_steps = tmp_steps.map {|k,v| [k, v.sum {|r| r[1]}]}.to_h

    chart_data = @daily_steps.map { |k, v| [k.strftime("%Y-%m-%d"), v] }
    first_bar_start_date = Date.parse(chart_data[0][0])
    last_month_start_date = first_bar_start_date - 1.months
    puts "Last Month Start Date"
    puts last_month_start_date
    last_month_end_date = first_bar_start_date - 1.day
    puts "Last Month End Date"
    puts last_month_end_date
    # Filter chart_data to only include data for the last week
    chart_data = chart_data.select { |date, value| Date.parse(date) >= last_month_start_date && Date.parse(date) <= last_month_end_date }
    
    last_month_total_steps = @response.select { |record| Date.parse(record['end_time']) >= last_month_start_date && Date.parse(record['end_time']) <= last_month_end_date }.map { |rec| [Date.parse(rec['end_time']), rec['value']] }.group_by { |r| r[0] }.to_h
    puts "Last Month Steps"
    puts last_month_total_steps
    last_month_daily_steps = last_month_total_steps.map { |k, v| [k, v.sum { |r| r[1] }] }.to_h
    puts "Last Month Daily Steps"
    puts last_month_daily_steps
    @daily_steps = last_month_daily_steps
  
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.json { render json: @daily_steps.to_json }
    end
  end
end
