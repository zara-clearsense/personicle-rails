class PhysicianController < ApplicationController
    before_action :require_user, :session_active?, :is_user_physician?, except: [:create_account]
    
    def index
        
        logger.info session[:oktastate]['credentials']['token']
        @physician = Physician.find_by(user_id: session[:oktastate]["uid"])
      
    end

    def get_user_data
        
        if request.get?
            return redirect_to pages_dashboard_physician_path
        end
        @physician = Physician.find_by(user_id: session[:oktastate]["uid"])
        start_time = 3.months.ago.strftime("%Y-%m-%d %H:%M:%S.%6N")
        end_time = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")
        url = ENV['EVENTS_ENDPOINT']+"?startTime="+start_time+"&endTime="+end_time+"&user_id="+params["data_for_user"]+"&event_type="+"Sleep"
        @user_data = JSON.parse(RestClient::Request.execute(:url => url, headers: {Authorization: "Bearer #{session[:oktastate]['credentials']['token']} "}, :method => :get,:verify_ssl => false ),object_class: OpenStruct)
        url_events = ENV['DATASTREAMS_ENDPOINT']+"?startTime="+start_time+"&endTime="+end_time+"&source=google-fit&datatype=com.personicle.individual.datastreams.step.count"+"&user_id="+params["data_for_user"]
      
        @user_events = JSON.parse(RestClient::Request.execute(:url => url_events, headers: {Authorization: "Bearer #{session[:oktastate]['credentials']['token']} "}, :method => :get,:verify_ssl => false ),object_class: OpenStruct)

        if !@user_events.empty?
            daily_steps = @user_events.map {|event| {'date' => event['timestamp'].to_datetime.to_date, 'value' => event['value']}}
            tmp = daily_steps.group_by {|rec| rec['date']}.to_h
            @daily_step_summary = tmp.map {|k,v| [k , v.sum {|r| r['value']}]}.to_h
            tmp2 = @daily_step_summary.group_by{|rec| rec[0].strftime('%Y-%U')}.to_h
            @weekly_step_summary = tmp2.map {|k,v| [k , v.sum {|r| r[1]}/ v.size]}.to_h
        else
            @daily_step_summary = []
            @weekly_step_summary  = []
        end
        if !@user_data.empty?

            daily_sleep = @user_data.map {|event| {'date' => event['end_time'].to_datetime.to_date,'duration' => 24*(event['end_time'].to_datetime - event['start_time'].to_datetime).to_f}}
           
            tmp = daily_sleep.group_by {|rec| rec['date']}.to_h
         
            max_date = daily_sleep.max {|rec| rec['date']}['date']
            min_date = daily_sleep.min {|rec| rec['date']}['date']
            @daily_sleep_summary = tmp.map {|k,v| [k , v.sum {|r| r['duration']}]}.to_h
            (min_date..max_date).each do |d|
                if ! @daily_sleep_summary.key?(d)
                    @daily_sleep_summary[d]=0
                end
            end
            @daily_sleep_summary = @daily_sleep_summary.sort.to_h
            tmp2 = daily_sleep.group_by {|rec| rec['date'].strftime('%Y-%U')}.to_h
            # puts daily_sleep
            @weekly_sleep_summary = tmp2.map {|k,v| [k , v.sum {|r| r['duration']}/ v.size]}.to_h
            moving_average_sleep = @daily_sleep_summary.each_cons(7).map {|recs| [recs.max {|r| r[0]}[0], recs.sum {|r| r[1]}/recs.sum {|r| (r[1] > 0)?1:0 }]}.to_h
                    
            (min_date..max_date).each do |d|
                @daily_sleep_summary[d] = {'duration'=> @daily_sleep_summary[d], 'moving_average' => moving_average_sleep[d]}
            end
        else
            @daily_sleep_summary = []
            @weekly_sleep_summary  = []
        end
        
        # logger.info  @weekly_sleep_summary
        # redirect_to pages_dashboard_physician_path, userdata: @user_data
        respond_to do |format|
            format.html {render :index, locals: {weekly_step_summary: @weekly_step_summary, daily_step_summary: @daily_step_summary, user_events: @user_events, daily_sleep_summary: @daily_sleep_summary, weekly_sleep_summary: @weekly_sleep_summary, user_data: @user_data, physician: @physician, user_id: params["data_for_user"]} }
        end
    end

    def create_account
    end

    def is_user_physician?
        if !session[:oktastate]["physician"]
            return redirect_to pages_dashboard_path
        end
    end
end