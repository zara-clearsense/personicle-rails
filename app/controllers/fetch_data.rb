class FetchData

    def self.get_events(ses=session,event=event_type)
        Rails.cache.fetch([:events,ses[:oktastate]['uid'],event], expires_in: 20.minutes) do
            three_months_ago = 3.months.ago.strftime("%Y-%m-%d %H:%M:%S.%6N")
            current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")
            if event
                url = ENV['EVENTS_ENDPOINT']+"?startTime="+three_months_ago+"&endTime="+current_time+"&event_type="+event
            else
                url = ENV['EVENTS_ENDPOINT']+"?startTime="+three_months_ago+"&endTime="+current_time
            end
            JSON.parse(RestClient::Request.execute(:url => url, headers: {Authorization: "Bearer #{ses[:oktastate]['credentials']['token']} "}, :method => :get,:verify_ssl => false ),object_class: OpenStruct)
           end
    end

    def self.get_datastreams(ses=session)
        Rails.cache.fetch([:datastreams,ses[:oktastate]['uid']], expires_in: 20.minutes) do
            start_date = 3.months.ago.strftime("%Y-%m-%d %H:%M:%S.%6N")
            end_date = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")
            @source = 'google-fit'
            @steps_data_type = 'com.personicle.individual.datastreams.step.count'
            url = ENV['DATASTREAMS_ENDPOINT']+"?startTime="+start_date+"&endTime="+end_date+"&source="+@source+"&datatype="+@steps_data_type
            JSON.parse(RestClient::Request.execute(:url => url, headers: {Authorization: "Bearer #{ses[:oktastate]['credentials']['token']} "}, :method => :get,:verify_ssl => false ),object_class: OpenStruct)
        end
    end
end