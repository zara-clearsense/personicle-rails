class PhysiciansApiController < ApplicationController
    def get_physician
        begin
           res = JSON.parse(RestClient::Request.execute(:url => "https://api.personicle.org/auth/authenticate", headers: {Authorization: request.authorization}, :method => :get ),object_class: OpenStruct)
  
           @user = User.find_by(user_id: res['user_id'])
           phy_id = params[:id]
           @phy = @user.physicians.filter {|phy| phy.user_id == phy_id}
           if(!@phy.empty?)
            return  render json: @phy
           else
            return  render status: :not_found, json: { error: "Requested physician does not exist for this user" }
           end
        rescue => exception
            if exception.response.code == 401
                return  render status: :unauthorized, json: { error: "Unauthorized. You are not authorized to access this resource." }
              end
        end
    end

    def get_all_physicians
        begin
            res = JSON.parse(RestClient::Request.execute(:url => "https://api.personicle.org/auth/authenticate", headers: {Authorization: request.authorization}, :method => :get ),object_class: OpenStruct)
            @physicians =  User.all.select { |u| u.is_physician == true }
            return  render json: @physicians
        rescue => exception
            if exception.response.code == 401
                return  render status: :unauthorized, json: { error: "Unauthorized. You are not authorized to access this resource." }
            end
        end
    end

    def get_users_physicians
        begin
            res = JSON.parse(RestClient::Request.execute(:url => "https://api.personicle.org/auth/authenticate", headers: {Authorization: request.authorization}, :method => :get ),object_class: OpenStruct)
            @user = User.find_by(user_id: res['user_id'])
              return  render json: @user.to_json(
                    only: [:name],
                     :include =>{
                        :physicians => {only: [:name,:user_id]}
                     }
                )
            
        rescue => exception
            if exception.response.code == 401
              return  render status: :unauthorized, json: { error: "Unauthorized. You are not authorized to access this resource." }
            end
        end
       
      
    end

end
