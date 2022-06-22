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
        st = 3.months.ago.strftime("%Y-%m-%d %H:%M:%S.%6N")
        et = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")
       
        if params[:refresh]=="hard_refresh"
            @user_data =  FetchData.get_events(session,event_type="Sleep",st,et,hard_refresh=true, uid=params["data_for_user"])
            @user_events = FetchData.get_datastreams(session,source="google-fit",data_type="com.personicle.individual.datastreams.step.count",st, et, hard_refresh=true,uid=params["data_for_user"])
            @user_hr  = FetchData.get_datastreams(session,source="google-fit",data_type="com.personicle.individual.datastreams.heartrate",st, et, hard_refresh=true,uid=params["data_for_user"])
            
        else
            @user_data =  FetchData.get_events(session,event_type="Sleep",st,et,hard_refresh=false, uid=params["data_for_user"])
            @user_events = FetchData.get_datastreams(session,source="google-fit",data_type="com.personicle.individual.datastreams.step.count",st, et, hard_refresh=false,uid=params["data_for_user"])
            @user_hr  = FetchData.get_datastreams(session,source="google-fit",data_type="com.personicle.individual.datastreams.heartrate",st, et, hard_refresh=false,uid=params["data_for_user"])
      
        end
       
        if !@user_hr.empty?
            one_day_ago = @user_hr.select {|hr| hr['timestamp'] >= 1.day.ago}
           
            one_day_ago_max_hr =  !one_day_ago.empty? ? one_day_ago.max_by {|hr| hr['value']}.value : 0
            one_day_ago_min_hr = !one_day_ago.empty? ? one_day_ago.min_by {|hr| hr['value']}.value : 0
            
            last_two_weeks = @user_hr.select {|hr| hr['timestamp'] >= 2.weeks.ago}
            @last_two_weeks_max_hr = !last_two_weeks.empty? ? last_two_weeks.max_by {|hr| hr['value']}.value : 0
            @last_two_weeks_min_hr = !last_two_weeks.empty? ? last_two_weeks.min_by {|hr| hr['value']}.value : 0
            @avg_24_hour_hr = !one_day_ago.empty? ?  one_day_ago.sum {|hr| hr['value']}/one_day_ago.size : 0
     
        else
            @last_two_weeks_max_hr= 0
            @last_two_weeks_min_hr = 0
            @avg_24_hour_hr = 0
        end
        #step data
        if !@user_events.empty?
            daily_steps = @user_events.map {|event| {'date' => event['timestamp'].to_datetime.to_date, 'value' => event['value']}}
            tmp = daily_steps.group_by {|rec| rec['date']}.to_h
            @daily_step_summary = tmp.map {|k,v| [k , v.sum {|r| r['value']}]}.to_h
            tmp2 = @daily_step_summary.group_by{|rec| rec[0].strftime('%Y-%U')}.to_h
            @weekly_step_summary = tmp2.map {|k,v| [k , v.sum {|r| r[1]}/ v.size]}.to_h

            tmp_steps = @user_events.select {|record| record['timestamp'].to_datetime > 30.days.ago}.map {|rec| [rec['timestamp'].to_date, rec['value']]}.group_by {|r| r[0]}.to_h
            @daily_steps = tmp_steps.map {|k,v| [k, v.sum {|r| r[1]}]}.to_h
    
      
            @last_month_total_steps = @daily_steps.select {|k,v| k > 30.days.ago}.sum {|k,v| v}
            @last_month_steps_days = @daily_steps.select {|k,v| k > 30.days.ago}.size
            @last_week_total_steps = @daily_steps.select {|k,v| k > 7.days.ago}.sum {|k,v| v}
            @last_week_steps_days = @daily_steps.select {|k,v| k > 7.days.ago}.size
      
            @last_week_average_steps = @last_week_steps_days>0? @last_week_total_steps/@last_week_steps_days:0
            @last_month_average_steps = @last_month_steps_days>0? @last_month_total_steps/@last_month_steps_days:0
        else
            @daily_step_summary = []
            @weekly_step_summary  = []
        end
        #sleep data 
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
            @weekly_sleep_summary = tmp2.map {|k,v| [k , v.sum {|r| r['duration']}/ v.size]}.to_h
            # moving_average_sleep = @daily_sleep_summary.each_cons(7).map {|recs| [recs.max {|r| r[0]}[0], recs.sum {|r| r[1]}/recs.sum {|r| (r[1] > 0)?1:0 }]}.to_h
                    
            (min_date..max_date).each do |d|
                @daily_sleep_summary[d] = {'duration'=> @daily_sleep_summary[d], 'moving_average' => 0}
            end

            @sleep_events = @user_data.select {|event| event['event_name'] == 'Sleep'}
   
            @last_month_total_sleep = @sleep_events.select {|event| event['start_time'].to_datetime > 30.days.ago}.sum {|event| event['parameters']['duration']}/(60*1000)
            @last_month_sleep_event = @sleep_events.select {|event| event['start_time'].to_datetime > 30.days.ago}.size
            @last_week_total_sleep = @sleep_events.select {|event| event['start_time'].to_datetime > 7.days.ago}.sum {|event| event['parameters']['duration']}/(60*1000)
            @last_week_sleep_event = @sleep_events.select {|event| event['start_time'].to_datetime > 7.days.ago}.size
            
            @last_week_average_sleep = @last_week_sleep_event>0? @last_week_total_sleep/@last_week_sleep_event:0
            @last_month_average_sleep = @last_month_sleep_event>0? @last_month_total_sleep/@last_month_sleep_event:0
        else
            @daily_sleep_summary = []
            @weekly_sleep_summary  = []
        end

        respond_to do |format|
            format.html {render :index, locals: {avg_24_hour_hr: @avg_24_hour_hr,last_two_weeks_min_hr: @last_two_weeks_min_hr,last_two_weeks_max_hr: @last_two_weeks_max_hr,weekly_step_summary: @weekly_step_summary, daily_step_summary: @daily_step_summary, user_events: @user_events, daily_sleep_summary: @daily_sleep_summary, weekly_sleep_summary: @weekly_sleep_summary, user_data: @user_data, physician: @physician, user_id: params["data_for_user"]} }
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