class SleepController < ApplicationController
    require 'json'
    require 'ostruct'
    require 'date'
    before_action :require_user, :session_active?

    def index
        start_time = 12.months.ago.strftime("%Y-%m-%d %H:%M:%S.%6N")
        current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")
        url = ENV['EVENTS_ENDPOINT']+"?startTime="+start_time+"&endTime="+current_time +"&event_type=Sleep"
        res = RestClient::Request.execute(:url => url, headers: {Authorization: "Bearer #{session[:oktastate]['credentials']['token']} "}, :method => :get,:verify_ssl => false )
        if res
            @response = JSON.parse(res,object_class: OpenStruct)
            if @response.size > 0
                daily_sleep = @response.map {|event| {'date' => event['start_time'].to_datetime.to_date,'duration' => 24*(event['end_time'].to_datetime - event['start_time'].to_datetime).to_f}}
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
        end
    end
end
