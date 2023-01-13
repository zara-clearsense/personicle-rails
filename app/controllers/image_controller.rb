class ImageController < ApplicationController
    before_action :require_params, only: %i[ upload_image ]
    before_action :require_user, :session_active?, :get_user_notifications
    require 'json'
    def upload
      

    end

    def delete_image
        image_key = params[:image_key]
        question_id = params[:question_id]
        # sql = "select value from physician_questionnaire where value->0->>'question_id' = 'images-ques' and value->0->>'value' = '91i43ridtyn2gw18yqmci1049do9'"
        sql = %{SELECT value FROM physician_questionnaire WHERE (value @> '[{
            "value": "#{image_key}",
            "question_id": "#{question_id}",
            "response_type": "image"
          }]')}
        
        record = ActiveRecord::Base.connection.exec_query(sql)
        data = record.rows
       
        data_to_update = []
        JSON.parse(data[0][0]).each do |r|
            puts r
            puts r.class
            puts r["value"]
            if r["value"] != image_key
                data_to_update.push(r)
            end
        end
       if data_to_update.length > 0
        data_to_update = data_to_update.to_json
       end
        update_stmt = %{UPDATE physician_questionnaire SET value = '#{data_to_update}' WHERE (value @> '[{
            "value": "#{image_key}",
            "question_id": "#{question_id}",
            "response_type": "image"
          }]')}
        update_response = ActiveRecord::Base.connection.exec_query(update_stmt)
        
        payload = {"image_ids": "#{image_key}"}
        res =  JSON.parse(RestClient::Request.execute(:url => "https://personicle-file-upload.herokuapp.com/user_images/delete", :payload => payload, headers: {Authorization: "Bearer #{session[:oktastate]['credentials']['token']} "}, :method => :delete ),object_class: OpenStruct)
        puts res
        Rails.cache.delete([:images,"com.personicle.individual.datastreams.subjective.physician_questionnaire",session[:oktastate]['uid']])
        return redirect_to pages_user_responses_path, refresh:"hard_refresh"
        # record.each do |k,v|
        #     puts k
        #     puts v
        # end
        
        
    end

    def send_packet

        image_data = params[:image_ids]
        values = []
        image_data.each do |k,v|
         values.append(v)
        end
        
        data = {"streamName": "com.personicle.individual.datastreams.subjective.image_uploads", "individual_id": "#{session[:oktastate]['uid']}",
                 "source": "Personicle:image_upload", "unit": "", "confidence": 100, "dataPoints":[{
                        "timestamp": Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N"),
                        "value": values
                    }]
               }
        # puts params.except(:authenticity_token, :individual_id,:controller, :action)
        # data = params.except(:authenticity_token, :individual_id,:controller, :action)
        # puts  data.to_json
  
        res = RestClient::Request.execute(:url => ENV['DATASTREAM_UPLOAD'], :payload => data.to_json, :method => :post, headers: {Authorization: "Bearer #{session[:oktastate]['credentials']['token']}", content_type: :json})
        puts res.code
        # puts res
    end

    def require_params
    #     params.require(:user_image).permit(:image,:timestamp,:individual_id)
    end
end