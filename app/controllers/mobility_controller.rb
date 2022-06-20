class MobilityController < ApplicationController
    require 'json'
    require 'ostruct'
    require 'date'
    before_action :require_user, :session_active?

  def index
    # add another request for specific data streams (step count)
    # use exercise for another chart
    st = 3.months.ago.strftime("%Y-%m-%d %H:%M:%S.%6N")
    et = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")
    if params.has_key?(:refresh) && params[:refresh]=="hard_refresh"
      puts "hard refresh"
      @response = FetchData.get_datastreams(session,source="google-fit",data_type="com.personicle.individual.datastreams.step.count",start_date=st, end_date=et, hard_refresh=true)
    else
      puts "not hard refresh"
      @response = FetchData.get_datastreams(session,source="google-fit",data_type="com.personicle.individual.datastreams.step.count",start_date=st, end_date=et, hard_refresh=false)
    end 
  #  puts @response
  #  puts "hello"

    if !@response.empty?

      @steps_data_raw = []
      @response.each { |record|
        timestamp_data = record['timestamp'].to_datetime
        @steps_data_raw.push({'minute_value' => timestamp_data.minute + timestamp_data.hour * 60, 'weekday' => record['timestamp'].to_datetime.strftime("%A"), 'value' => record['value']})
      }

      all_minutes = [*0..1439]
      all_days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']

      weekday_grouped_data = @steps_data_raw.group_by { |rec| rec['weekday']}.to_h
      
      # puts weekday_grouped_data['Monday']

      @processed_steps_data = {}
      all_days.each { |week_day|
        if weekday_grouped_data.key?(week_day)
          current_day_data = weekday_grouped_data[week_day]
          summarized_data = current_day_data.group_by {|rec| rec['minute_value']/30}.map {|k, v| [k, (v.size>0)?(v.sum {|r| r['value']}.to_f/90) : 0]}.to_h
          # summarized_data = current_day_data.group_by {|rec| rec[0]}.to_h {|k, v| [k, v.sum {|r| r[1]}]}
          @processed_steps_data[week_day] = summarized_data
        end
      }

      temporary_steps = @response.group_by_day{|rec| rec['timestamp'].to_datetime}.to_h 
      @mobility_aggregated = temporary_steps.map {|k,v| {k => v.sum {|r| r['value']}}}
      puts @mobility_aggregated
    else
      processed_steps_data = {}
    end
  end
end
