class ImageController < ApplicationController
    before_action :require_params, only: %i[ upload_image ]
    before_action :require_user, :session_active?
 
    def upload

    end

    def upload_image
        puts "hello"
        puts params.except(:authenticity_token, :individual_id,:controller, :action)
        data = params.except(:authenticity_token, :individual_id,:controller, :action)
        puts  data.to_json
        res = RestClient::Request.execute(:url =>"http://localhost:3001/user_images", :payload => data.to_json, :multipart => true,:method => :post, headers: {Authorization: "Bearer #{session[:oktastate]['credentials']['token']}"})
        puts res.code
        puts res
    end

    def require_params
    #     params.require(:user_image).permit(:image,:timestamp,:individual_id)
    end
end