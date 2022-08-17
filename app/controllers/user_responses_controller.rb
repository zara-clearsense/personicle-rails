class UserResponsesController < ApplicationController
    before_action :require_user, :session_active?
    # format data for chart
    # args: user_repsonses, data_type (physician_questionnaire or user_questionnaire, physician_response: bool)
    def format_data_to_visualize(user_responses,data_type,physician_responses)
           timestamped_responses = []
            user_responses.each do |rec|
                    current_timestamp = rec['timestamp']
                    responses = rec['value']
                    phy = physician_responses ? rec['source'].split(":")[1]  : ""
                    responses.each do |resp|
                        timestamped_responses.push({'timestamp'=> current_timestamp, 'physician' => phy, 'question_id'=> resp['question-id'], 'response' => resp['value'], 'response_type' => resp['response_type']})
                    end
            end

            question_indexed_responses = timestamped_responses.group_by {|rec| [rec['question_id'], rec['timestamp'].to_date, rec['response'], rec['response_type'], rec['physician']]}.to_h
            image_responses = timestamped_responses.filter {|rec| rec['response_type'] == 'image'}.group_by{|rec| rec['question_id']}.to_h
            user_responses = question_indexed_responses.map{|k,v| [k, v.size()]}
            
            unique_tags  = user_responses.uniq{|rec| rec[0][0]}.collect{|rec| rec[0][0]}
            
            # @images =  user_responses.select{|rec| rec[0][3] == 'image'}
            
            image_urls = []

            if params[:refresh]!="hard_refresh" && Rails.cache.fetch([:images,data_type,session[:oktastate]['uid']])
                image_urls = Rails.cache.read([:images,data_type,session[:oktastate]['uid']])
            else
                image_responses.each do |k,v|
                    v.each do |val|
                        image_keys = val['response'].split(";")
                            image_keys.each do |key|
                                begin
                                    
                                    res = JSON.parse(RestClient::Request.execute(:url => "https://personicle-file-upload.herokuapp.com/user_images/#{key}?user_id=#{session[:oktastate]['uid']}", headers: {Authorization: "Bearer #{session[:oktastate]['credentials']['token']} "}, :method => :get,:verify_ssl => false ),object_class: OpenStruct)
                                    # puts key
                                    image_urls.push([k, val['timestamp'], res['image_url']])
                                rescue => exception
                                    puts "deleted key " + key
                                    next
                                end
                            
                        end
                    end
                end
                image_urls = image_urls.group_by {|rec| rec[0]}.to_h

                Rails.cache.write([:images,data_type,session[:oktastate]['uid']],image_urls, expires_in: 12.minutes)
            end
         return user_responses, unique_tags, image_urls
    end

    def index
        st = 3.months.ago.strftime("%Y-%m-%d %H:%M:%S.%6N")
        et = Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")
     
        if params[:refresh]=="hard_refresh"
           user_responses  = FetchData.get_datastreams(session,source=nil,data_type="com.personicle.individual.datastreams.subjective.user_questionnaire",st, et, hard_refresh=true,uid=session[:oktastate]['uid'])
           user_physician_responses = FetchData.get_datastreams(session,source=nil,data_type="com.personicle.individual.datastreams.subjective.physician_questionnaire",st, et, hard_refresh=true,uid=session[:oktastate]['uid'])
        else
           user_responses  = FetchData.get_datastreams(session,source=nil,data_type="com.personicle.individual.datastreams.subjective.user_questionnaire",st, et, hard_refresh=false,uid=session[:oktastate]['uid'])
           user_physician_responses = FetchData.get_datastreams(session,source=nil,data_type="com.personicle.individual.datastreams.subjective.physician_questionnaire",st, et, hard_refresh=false,uid=session[:oktastate]['uid'])

        end
        # puts user_responses
        if !user_responses.empty? 
         @user_responses, @unique_tags, @image_urls  = format_data_to_visualize(user_responses,"com.personicle.individual.datastreams.subjective.user_questionnaire",false)
        end
        if !user_physician_responses.empty?
            @user_responses_physician, @unique_tags_physician, @image_urls_physician  = format_data_to_visualize(user_physician_responses,"com.personicle.individual.datastreams.subjective.physician_questionnaire",true)
            @unique_physicians = @user_responses_physician.uniq {|rec| rec[0][4]}.collect{|rec| rec[0][4]}
        end
       
    end #index end


end