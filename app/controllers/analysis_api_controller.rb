class AnalysisApiController < ApplicationController
    def get_event_metadata
        begin
           res = JSON.parse(RestClient::Request.execute(:url => "https://api.personicle.org/auth/authenticate", headers: {Authorization: request.authorization}, :method => :get ),object_class: OpenStruct)
  
           @user = User.find_by(user_id: res['user_id'])
           # get user events metadata for the user id in the request
           # return the events metadata in the required JSON format
        rescue => exception
            if exception.response.code == 401
                return  render status: :unauthorized, json: { error: "Unauthorized. You are not authorized to access this resource." }
              end
        end
    end

    def get_datastream_metadata
        begin
           res = JSON.parse(RestClient::Request.execute(:url => "https://api.personicle.org/auth/authenticate", headers: {Authorization: request.authorization}, :method => :get ),object_class: OpenStruct)
  
           @user = User.find_by(user_id: res['user_id'])
           # get user datastream metadata for the user id in the request
           # return the datastream metadata in the required JSON format
        rescue => exception
            if exception.response.code == 401
                return  render status: :unauthorized, json: { error: "Unauthorized. You are not authorized to access this resource." }
              end
        end
    end

end
