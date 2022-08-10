class CreateUserQuestionsController < ApplicationController
    before_action :require_user, :session_active?
    def index
        @user_questions = User.find_by(user_id: session[:oktastate]['uid']).questions
        
    end

    def send_responses
        question_reponses = params.except(:authenticity_token,:controller, :action)
        user_questions_responses = {}
        question_reponses.each do |k,v|
            payload = {"response": v , "tag": k.split(" ")[1] , "response_type": k.split(" ")[2] }
            if user_questions_responses.empty?
                user_questions_responses[k.split(" ")[0]] = [ payload ]
            else
                user_questions_responses[k.split(" ")[0]].push(payload) 
            end 
        end

        user_questions_responses.each do |key,value|
            responses, filtered_image_responses, filtered_survey_responses, filtered_string_responses, filtered_numeric_responses =  get_filtered_responses(value)
            image_response_packet = []

            code, image_validation_response = client_image_validation(filtered_image_responses) if !filtered_image_responses.empty? # client validation for quicker responses
            if code == 422
                flash[:danger] = image_validation_response
                return redirect_to pages_user_create_question_path(responses_send: false)
            end

            image_response_packet = make_image_response_packet(responses,filtered_image_responses)
            final_data_packet = make_data_packet(filtered_survey_responses,filtered_numeric_responses,filtered_string_responses)

            # add image data packet
            final_data_packet.append(image_response_packet) if !image_response_packet.empty?

            final_data_packet =  final_data_packet.flatten!

            if !final_data_packet.nil?
                data = {"streamName": "com.personicle.individual.datastreams.subjective.user_questionnaire", "individual_id": "#{session[:oktastate]["uid"]}",
                        "source": "Personicle:#{key}", "unit": "", "confidence": 100, "dataPoints":[{ "timestamp": Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N"), "value": final_data_packet }]
                        }
            
                res = RestClient::Request.execute(:url => ENV['DATASTREAM_UPLOAD'], :payload => data.to_json, :method => :post, headers: {Authorization: "Bearer #{session[:oktastate]['credentials']['token']}", content_type: :json})
                if res.code == 200
                    flash[:success] = "Your responses are recorded"
                    return redirect_to pages_user_create_question_path(responses_send: true)
                else
                    flash[:warning] = "Something went wrong. Please try again"
                    return redirect_to pages_user_create_question_path(responses_send: false)
                end
            end
            flash[:warning] = "Something went wrong. Please try again"
            return  redirect_to pages_user_create_question_path(responses_send: false)
        end
    end

    def create
        @user = User.find_by(user_id: session[:oktastate]['uid'])
        new_question = params[:user_questions]
        tag = params[:user_tag]
        options = params[:user_options].to_a
        payload = {
            "question": new_question,
            "tag": tag.gsub(/\s+/, ""),
            "options": options,
            "response_type": params[:user_response_type]
        }

        if @user.questions.empty?
            @user.questions['questions'] = [payload]
        else
            tag_exists = @user.questions['questions'].filter {|q| q['tag'] == tag}

            if tag_exists.empty? #unique tag provided
                @user.questions['questions'].push(payload)
            else
                flash[:warning] = "Tag already exists. Please provide a different Tag."
                return redirect_to pages_user_create_question_path
            end
        end
        @user.save
        flash[:success] = "Question created successfully"
        return redirect_to pages_user_create_question_path
    end
end
