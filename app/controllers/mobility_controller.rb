class MobilityController < ApplicationController
    require 'json'
    require 'ostruct'
    require 'date'
    before_action :require_user, :session_active?

  def index
    puts session[:oktastate]['credentials']['token']
    start_date = 3.months.ago.strftime("%Y-%m-%d %H:%M:%S.%6N")
    end_date = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")

    @source = 'google-fit'
    @steps_data_type = 'com.personicle.individual.datastreams.step.count'
    # @week_day = params[:day_of_week] || 'Monday'
    # get steps data here
    url = ENV['DATASTREAMS_ENDPOINT']+"?startTime="+start_date+"&endTime="+end_date+"&source="+@source+"&datatype="+@steps_data_type
    res = RestClient::Request.execute(:url => url, headers: {Authorization: "Bearer #{session[:oktastate]['credentials']['token']} "}, :method => :get,:verify_ssl => false )
    # add another request for specific data streams (step count)
    # use exercise for another chart
    if res
      @response = JSON.parse(res,object_class: OpenStruct)
    #   .map{|rec| rec['minute']=rec['timestamp'].to_datetime.minute}
      @steps_data_raw = []
      @response.each { |record|
        timestamp_data = record['timestamp'].to_datetime
        @steps_data_raw.push({'minute_value' => timestamp_data.minute + timestamp_data.hour * 60, 'weekday' => record['timestamp'].to_datetime.strftime("%A"), 'value' => record['value']})
      }

      all_minutes = [*0..1439]
      all_days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']

      weekday_grouped_data = @steps_data_raw.group_by { |rec| rec['weekday']}.to_h
      
    #   puts weekday_grouped_data['Monday']

      @processed_steps_data = {}
      all_days.each { |week_day|
        current_day_data = weekday_grouped_data[week_day]
        summarized_data = current_day_data.group_by {|rec| rec['minute_value']/30}.map {|k, v| [k, (v.size>0)?(v.sum {|r| r['value']}.to_f/90) : 0]}.to_h
        # summarized_data = current_day_data.group_by {|rec| rec[0]}.to_h {|k, v| [k, v.sum {|r| r[1]}]}
        @processed_steps_data[week_day] = summarized_data
      }
    end
  end
end