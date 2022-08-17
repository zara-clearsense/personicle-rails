class ExposomeController < ApplicationController
    require 'json'
    require 'ostruct'
    require 'date'
    before_action :require_user, :session_active?, :get_user_notifications
    
   def index
        # Create array of exposomes
        
        
        # if !params[:noti_id].nil? &&  !params[:noti_id].blank? 
        #     @notification_read = Notification.find_by(id: params[:noti_id]).mark_as_read!
        # end
    # 
    # @notification_read.save
    @exposome_streams = [
        "com.personicle.individual.datastreams.exposome.aqi",
        "com.personicle.individual.datastreams.exposome.no",
        "com.personicle.individual.datastreams.exposome.no2",
        "com.personicle.individual.datastreams.exposome.03",
        "com.personicle.individual.datastreams.exposome.so2",
        "com.personicle.individual.datastreams.exposome.pm2_5",
        "com.personicle.individual.datastreams.exposome.pm10",
        "com.personicle.individual.datastreams.exposome.nh3",
        "com.personicle.individual.datastreams.exposome.temp",
        "com.personicle.individual.datastreams.exposome.feels_like",
        "com.personicle.individual.datastreams.exposome.pressure",
        "com.personicle.individual.datastreams.exposome.humidity",
        "com.personicle.individual.datastreams.exposome.uvi"
    ]

    # Loop over array of exposomes and make request to API to get that data from the loop
    st = 3.months.ago.strftime("%Y-%m-%d %H:%M:%S.%6N")
    et = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")
   
    # For each call of this API, need to store this data in hash variable / hash object
    @exposome_streams_hash = {}
    @exposome_streams.each { |datastream| 
        if params.has_key?(:refresh) && params[:refresh]=="hard_refresh"
            @response = FetchData.get_datastreams(session,source="org.personicle.exposome",data_type=datastream,start_date=st, end_date=et, hard_refresh=true,uid=session[:oktastate]['uid'])
            @exposome_streams_hash[datastream] = @response
            # -- all the views will be able to access that hash object, so when generating chart for temperature
            # can pass object specific for temperature
            # In chart, use time stamp and value fields to generate the chart. 
        else   
            @response = FetchData.get_datastreams(session,source="org.personicle.exposome",data_type=datastream,start_date=st, end_date=et, hard_refresh=false,uid=session[:oktastate]['uid'])
            @exposome_streams_hash[datastream] = @response
        end
    }
    # puts @exposome_streams_hash
    # One chart contains all values for nitrogen compounds, one chart for carbon based compounds, one for sulphur based compounds, one for temperature
    # When the data type is temperature, add that data to a hash object


    # In views, pass that data/hash object to the chart element 
    # In chart element, get time stamp and the value and show that on the chart

    # All views will be able to access hash object - pass temperature object or hash object

    # 
end
end