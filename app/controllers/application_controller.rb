class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :logged_in?, :require_user, :session_active?, :is_physician?, :get_user_notifications
  

  def get_user_notifications
     @current_user = User.find_by(user_id: session[:oktastate]['uid'])
     @notifications = @current_user.notifications.unread
     return @notifications
  end

  def user_is_logged_in?
    if !session[:oktastate]
      # redirect_to user_oktaoauth_omniauth_authorize_path
      root_path
    end
  end

  def is_physician?
    url = "https://dev-01936861.okta.com/api/v1/users/#{session[:oktastate]['uid']}/groups"
    res = JSON.parse(RestClient::Request.execute(:url => url, headers: {Authorization: ENV['GET_USER_GROUP_TOKEN']}, :method => :get ))
      
      for r in res
        if r['id'] == ENV['PHYSICIAN_GROUP_ID']
          session[:oktastate][:physician] = true
          return true
        end
      end
    return false

  end
  # def login_type_physician?
  #   # puts "hello"
  #   # puts session[:oktastate]
  #   # puts session[:oktastate]["physician"]
  #   if !session[:oktastate]["physician"]
  #     flash[:danger] = "You do not have access to physician dashboard"
  #     redirect_to pages_dashboard_path
  #   end
  # end

  # def login_type_user?
  #   if session[:oktastate]["physician"]
  #     flash[:danger] = "You do not have access to user dashboard"
  #     redirect_to pages_dashboard_physician_path
  #   end
  # end

  def session_active?
    if session[:oktastate]
      access_token = session[:oktastate]['credentials']['token']

      url = ENV['TOKEN_INTROSPECTION']+"?token="+access_token
      
      res = RestClient::Request.execute(:url => url, headers: {Authorization: "Basic #{ENV['BASE_64_CLIENT']}", :content_type =>'application/x-www-form-urlencoded'}, :method => :post)
      is_active =  JSON.parse(res)['active']
      
      if !is_active
        flash[:danger] = "Your session has expired. Please login again"
        redirect_to root_path
      end
    end
  end

  def hard_refresh?
    
  end

  def logged_in?
    !session[:oktastate].nil?
  end

  def require_user
    if !logged_in? 
        flash[:danger] = "You must be logged in to perform that action"
        redirect_to root_path
    end
  end

  def after_sign_in_path_for(resource)
    resource.env['omniauth.origin'] || root_path
  end



  def handle_image_response(image_resp)
    # puts "inside handle_image_response"
    images = []
    image_resp.each do |i|
        images.append(i)
    end
    
    data = {"images": images, "individual_id": session[:oktastate]['uid']}
    begin
        res = RestClient::Request.execute(:url => 'https://personicle-file-upload.herokuapp.com/user_images', :payload => {:multipart => true, :user_image => data}, headers: {Authorization: "Bearer #{session[:oktastate]['credentials']['token']}"}, :method => :post )
        json_res = JSON.parse(res)
        return res.code, json_res
    rescue => exception
        return exception.response.code , exception.response
    end
  end

  def client_image_validation(images)
    # puts "client image validatoin"
    # puts images
    images.each do |image|
        image[:value].each do |i|
            # puts i
            if !i.content_type.in?(%('image/jpeg image/png image/jpg'))
                return 422, "Invalid file type. Images need to be a jpeg or png!"
            end
            if i.size > 5.megabytes
                return 422, "Images should be less than 5mb!"
            end
        end
    end
  end
 
  def get_filtered_responses(value)
    responses = []
    value.each do |v|
        responses.append({
            "question-id": v[:tag],
            "value": v[:response],
            "response_type": v[:response_type]
        })
    end
    filtered_image_responses = responses.filter {|resp| resp[:response_type] == "image"}
    filtered_survey_responses = responses.filter {|resp| resp[:response_type] == "survey"}
    filtered_string_responses = responses.filter {|resp| resp[:response_type] == "string"}
    filtered_numeric_responses = responses.filter {|resp| resp[:response_type] == "numeric"}
    return responses, filtered_image_responses, filtered_survey_responses, filtered_string_responses, filtered_numeric_responses
  end
  
  def make_image_response_packet(responses, filtered_image_responses)
    image_response_packet = []
    responses.filter {|resp| resp[:response_type] == "image"}.map {|k,v| [k[:'question-id'], k[:value]]}.to_h.each do |tag, files|
        image_keys = []
        image_upload_code, image_upload_response =  !filtered_image_responses.empty? ? handle_image_response(files) :  break
      
        if image_upload_code != 201 # an invali image was uploaded
            flash[:danger] = image_upload_response
           return redirect_to pages_dashboard_physician_questions_path(responses_send: false)
        end
        image_upload_response.each do |r|
            image_keys.append(r["image_key"])
        end
        image_keys = image_keys.join(";")
        image_response_packet.append({
            "question-id": tag,
            "value": image_keys,
            "response_type": "image"
        })
    end
    return image_response_packet
  end



  def make_data_packet(survey, numeric, string )
    survey_response_packet = []
    numeric_response_packet = []
    string_response_packet = []
    data_packet = []
    survey.each do |survey_resp|
        if !survey_resp[:value].empty?
            survey_response_packet.append({
                "question-id": survey_resp[:'question-id'],
                "value": survey_resp[:value],
                "response_type": "survey"
            })
        end
    end

    numeric.each do |numeric_resp|
        if !numeric_resp[:value].empty?
            numeric_response_packet.append({
                "question-id": numeric_resp[:'question-id'],
                "value": numeric_resp[:value].to_s,
                "response_type": "numeric"
            })
        end
    end

    string.each do |string_resp|
        if !string_resp[:value].empty?
            string_response_packet.append({
                "question-id": string_resp[:'question-id'],
                "value": string_resp[:value].to_s,
                "response_type": "string"
            })
        end
    end
    data_packet.append(survey_response_packet) if  !survey_response_packet.empty?
    data_packet.append(numeric_response_packet) if !numeric_response_packet.empty?
    data_packet.append(string_response_packet) if !string_response_packet.empty?
    return data_packet
  end

end
