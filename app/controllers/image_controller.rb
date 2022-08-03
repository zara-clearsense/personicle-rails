class ImageController < ApplicationController
    before_action :require_params, only: %i[ upload_image ]
    before_action :require_user, :session_active?
 
    def upload

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