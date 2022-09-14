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

    def get_exposome_data
        required = [ :exposomeType]
        @exposome_streams = [
        ["aqi", "com.personicle.individual.datastreams.exposome.aqi"],
        ["no", "com.personicle.individual.datastreams.exposome.no"],
        ["no2", "com.personicle.individual.datastreams.exposome.no2"],
        ["03", "com.personicle.individual.datastreams.exposome.03"],
        ["so2", "com.personicle.individual.datastreams.exposome.so2"],
        ["pm2_5", "com.personicle.individual.datastreams.exposome.pm2_5"],
        ["pm10", "com.personicle.individual.datastreams.exposome.pm10"],
        ["nh3", "com.personicle.individual.datastreams.exposome.nh3"],
        ["temp", "com.personicle.individual.datastreams.exposome.temp"],
        ["feels_like", "com.personicle.individual.datastreams.exposome.feels_like"],
        ["pressure", "com.personicle.individual.datastreams.exposome.pressure"],
        ["humidity", "com.personicle.individual.datastreams.exposome.humidity"],
        ["uvi", "com.personicle.individual.datastreams.exposome.uvi"]
       ]

        form_complete = true
        required.each do |k|
            if params.has_key?(k) and not params[k].blank?
            else
                form_complete = false
            end
        end
        puts params[:exposomeType]
        # Loop over array of exposomes and make request to API to get that data from the loop
        st = 3.months.ago.strftime("%Y-%m-%d %H:%M:%S.%6N")
        et = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")

        exposome_type = params[:exposomeType]
        puts exposome_type

        # For each call of this API, need to store this data in hash variable / hash object
        # @exposome_streams_hash = {}
        if form_complete
            if params.has_key?(:refresh) && params[:refresh]=="hard_refresh"
                @response = FetchData.get_datastreams(session,source="org.personicle.exposome",data_type=exposome_type,start_date=st, end_date=et, hard_refresh=true,uid=session[:oktastate]['uid'])
                # @exposome_streams_hash[exposome_type] = @response
                exposome_data = @response
                # -- all the views will be able to access that hash object, so when generating chart for temperature
                # can pass object specific for temperature
                # In chart, use time stamp and value fields to generate the chart.
                puts "real exposome"
                puts @exposome_streams[0] 
            else   
                @response = FetchData.get_datastreams(session,source="org.personicle.exposome",data_type=exposome_type,start_date=st, end_date=et, hard_refresh=false,uid=session[:oktastate]['uid'])
                # @exposome_streams_hash[exposome_type] = @response
                exposome_data = @response
                puts "real exposome"
                puts @exposome_streams[0]
            end

            if !@response.empty?
                exposome_type = exposome_type.split(".")[-1]
            else
            end

            
            #puts exposome_data
            respond_to do |format|
                format.html {render :index, locals: { exposome_data: exposome_data, exposome_type: exposome_type } }
                # redirect_to pages_recipes_path, recipes: response.hits
            end
        else
            respond_to do |format|
                format.html {render :index, locals: { status_msg: "An error occured while fetching exposome data" } }
                # redirect_to pages_recipes_path, recipes: response.hits
            end
        end
    end
end
  
  