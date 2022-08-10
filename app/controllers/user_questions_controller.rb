class UserQuestionsController < ApplicationController
    before_action :require_user, :session_active?
    def index
        @questions = {}
        @user = User.find_by(user_id: session[:oktastate]['uid'])

        @user.physicians.each do |phy|
            @physician_questions = PhysicianUser.find_by(user_user_id: session[:oktastate]['uid'], physician_user_id: phy.user_id).questions
            puts @physician_questions
            @questions[[phy.id,phy.name]] = @physician_questions if !@physician_questions.empty?
             
        end
    end

    # def client_image_validation(images)
    #     # puts "client image validatoin"
    #     # puts images
    #     images.each do |image|
    #         image[:value].each do |i|
    #             # puts i
    #             if !i.content_type.in?(%('image/jpeg image/png image/jpg'))
    #                 return 422, "Invalid file type. Images need to be a jpeg or png!"
    #             end
    #             if i.size > 5.megabytes
    #                 return 422, "Images should be less than 5mb!"
    #             end
    #         end
    #     end
    # end
    # def handle_image_response(image_resp)
    #     # puts "inside handle_image_response"
    #     images = []
    #     image_resp.each do |i|
    #         images.append(i)
    #     end
        
    #     data = {"images": images, "individual_id": session[:oktastate]['uid']}
    #     begin
    #         res = RestClient::Request.execute(:url => 'https://personicle-file-upload.herokuapp.com/user_images', :payload => {:multipart => true, :user_image => data}, headers: {Authorization: "Bearer #{session[:oktastate]['credentials']['token']}"}, :method => :post )
    #         json_res = JSON.parse(res)
    #         return res.code, json_res
    #     rescue => exception
    #         return exception.response.code , exception.response
    #     end
    # end

    # returns data packet for survey, numeric and string responses
    # def make_data_packet(survey, numeric, string )
    #     survey_response_packet = []
    #     numeric_response_packet = []
    #     string_response_packet = []
    #     data_packet = []
    #     survey.each do |survey_resp|
    #         if !survey_resp[:value].empty?
    #             survey_response_packet.append({
    #                 "question-id": survey_resp[:'question-id'],
    #                 "value": survey_resp[:value],
    #                 "response_type": "survey"
    #             })
    #         end
    #     end

    #     numeric.each do |numeric_resp|
    #         if !numeric_resp[:value].empty?
    #             numeric_response_packet.append({
    #                 "question-id": numeric_resp[:'question-id'],
    #                 "value": numeric_resp[:value].to_s,
    #                 "response_type": "numeric"
    #             })
    #         end
    #     end

    #     string.each do |string_resp|
    #         if !string_resp[:value].empty?
    #             string_response_packet.append({
    #                 "question-id": string_resp[:'question-id'],
    #                 "value": string_resp[:value].to_s,
    #                 "response_type": "string"
    #             })
    #         end
    #     end
    #     data_packet.append(survey_response_packet) if  !survey_response_packet.empty?
    #     data_packet.append(numeric_response_packet) if !numeric_response_packet.empty?
    #     data_packet.append(string_response_packet) if !string_response_packet.empty?
    #     return data_packet
    # end
   
  
    def send_responses   
        # puts "hello"
        # puts params
        question_reponses = params.except(:authenticity_token,:controller, :action)
        physicians_questions_responses = {}
        question_reponses.each do |k,v|
            payload = {"response": v , "tag": k.split(" ")[1] , "response_type": k.split(" ")[2] }
            if physicians_questions_responses.empty?
                physicians_questions_responses[k.split(" ")[0]] = [ payload ]
            else
                physicians_questions_responses[k.split(" ")[0]].push(payload) 
            end 
        end
        
        physicians_questions_responses.each do |key,value|

           responses, filtered_image_responses, filtered_survey_responses, filtered_string_responses, filtered_numeric_responses =  get_filtered_responses(value)

            code, image_validation_response = client_image_validation(filtered_image_responses) if !filtered_image_responses.empty? # client validation for quicker responses
            if code == 422
                flash[:danger] = image_validation_response
                return redirect_to pages_dashboard_physician_questions_path(responses_send: false)
            end
            # map of question tag and images
            
            image_response_packet = make_image_response_packet(responses,filtered_image_responses)
            final_data_packet = make_data_packet(filtered_survey_responses,filtered_numeric_responses,filtered_string_responses)

            # add image data packet
            final_data_packet.append(image_response_packet) if !image_response_packet.empty?

            final_data_packet =  final_data_packet.flatten!
            
            
            if !final_data_packet.nil?
                data = {"streamName": "com.personicle.individual.datastreams.subjective.physician_questionnaire", "individual_id": "#{session[:oktastate]["uid"]}",
                        "source": "Personicle:#{key}", "unit": "", "confidence": 100, "dataPoints":[{ "timestamp": Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N"), "value": final_data_packet }]
                        }
            
                res = RestClient::Request.execute(:url => ENV['DATASTREAM_UPLOAD'], :payload => data.to_json, :method => :post, headers: {Authorization: "Bearer #{session[:oktastate]['credentials']['token']}", content_type: :json})
                if res.code == 200
                    flash[:success] = "Your responses are recorded"
                    return redirect_to pages_dashboard_physician_questions_path(responses_send: true)
                else
                    flash[:warning] = "Something went wrong. Please try again"
                    return redirect_to pages_dashboard_physician_questions_path(responses_send: false)
                end
            end
            flash[:warning] = "Something went wrong. Please try again"
            return  redirect_to pages_dashboard_physician_questions_path(responses_send: false)
              
        end
      
    end
end
