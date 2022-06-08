class SleepController < ApplicationController
    require 'json'
    require 'ostruct'
    require 'date'
    before_action :require_user, :session_active?

    def index
        # url = ENV['EVENTS_ENDPOINT']+"?startTime="+start_time+"&endTime="+current_time+"&event_type=Sleep"
        # res = RestClient::Request.execute(:url => url, headers: {Authorization: "Bearer #{session[:oktastate]['credentials']['token']} "}, :method => :get,:verify_ssl => false )
        if params[:refresh]=="hard_refresh"
            puts "hard refresh"
            @response = FetchData.get_events(session,event_type="Sleep",hard_refresh=true)
            @response_bike = FetchData.get_events(session, event_type="Biking", hard_refresh=true)
            @response_run = FetchData.get_events(session, event_type="Running", hard_refresh=true)
          else
            puts "not hard refresh"
            @response = FetchData.get_events(session,event_type="Sleep",hard_refresh=false)
            @response_bike = FetchData.get_events(session, event_type="Biking", hard_refresh=false)
            @response_run = FetchData.get_events(session, event_type="Running", hard_refresh=false)
          end 

        if @response
        
            daily_sleep = @response.map {|event| {'date' => event['end_time'].to_datetime.to_date,'duration' => 24*(event['end_time'].to_datetime - event['start_time'].to_datetime).to_f}}
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
            moving_average_sleep = @daily_sleep_summary.each_cons(7).map {|recs| [recs.max {|r| r[0]}[0], recs.sum {|r| r[1]}/recs.sum {|r| (r[1] > 0)?1:0 }]}.to_h
                
            (min_date..max_date).each do |d|
                @daily_sleep_summary[d] = {'duration'=> @daily_sleep_summary[d], 'moving_average' => moving_average_sleep[d]}
            end
        
                # puts max_date, min_date
                # puts @daily_sleep_summary
        else
            @daily_sleep_summary = []
        end

        if @response_bike
            bike_days = @response_bike.map {|event| event['end_time'].to_datetime.to_date.next_day(1)}


        else
            bike_days = []
        end
        # puts "bike days"
        # puts bike_days

        if @response_run
            run_days = @response_run.map {|event| event['end_time'].to_datetime.to_date.next_day(1)}

        else
            run_days = []
        end
        # puts "run days"
        # puts run_days

        sleep_window = 15

        exercise_days = (run_days | bike_days)
        @exercise_days_sleep = []
        exercise_days.each do |d|
            if @daily_sleep_summary.key?(d)
                @exercise_days_sleep = @exercise_days_sleep.append(((@daily_sleep_summary[d]['duration']*60).to_i / sleep_window)*sleep_window)
            end
        end
        @exercise_days_sleep = @exercise_days_sleep.select{|v| v>0}
        @exercise_sleep_count = {}
        total_count = 0
        @exercise_days_sleep.each do |v|
            total_count = total_count+1
            if @exercise_sleep_count.key?(v)
                @exercise_sleep_count[v] = @exercise_sleep_count[v]+1
            else
                @exercise_sleep_count[v] = 1
            end
        end
        @exercise_sleep_count = @exercise_sleep_count.map{|k,v| [k , v.to_f/total_count]}.to_h
        # puts "exercise sleep count"
        # puts @exercise_sleep_count

        other_days = (min_date..max_date).select {|v| !bike_days.include? v}
        other_days = other_days.select {|v| !run_days.include? v}

        @other_days_sleep = []
        other_days.each do |d|
            @other_days_sleep = @other_days_sleep.append(((@daily_sleep_summary[d]['duration']*60).to_i / sleep_window) * sleep_window)
        end
        @other_days_sleep = @other_days_sleep.select{|v| v>0}
        @other_sleep_count = {}
        total_count = 0
        @other_days_sleep.each do |v|
            total_count = total_count+1
            if @other_sleep_count.key?(v)
                @other_sleep_count[v] = @other_sleep_count[v]+1
            else
                @other_sleep_count[v] = 1
            end
        end
        @other_sleep_count = @other_sleep_count.map{|k,v| [k , v.to_f/total_count]}.to_h
        # puts "other sleep count"
        # puts @other_sleep_count
        
    end
end
