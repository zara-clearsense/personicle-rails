class UserQuestionsController < ApplicationController
    before_action :require_user, :session_active?
    def index
        @questions = {}
        @user = User.find_by(user_id: session[:oktastate]['uid'])

        @user.physicians.each do |phy|
            @physician_questions = PhysicianUser.find_by(user_user_id: session[:oktastate]['uid'], physician_user_id: phy.user_id).questions
            
            @questions[[phy.id,phy.name]] = @physician_questions if !@physician_questions.empty?
            
        end
    end

    def send_responses   
        
        question_reponses = params.except(:authenticity_token,:controller, :action)
        
  
        physicians_questions_responses = {}
        question_reponses.each do |k,v|
            puts  k.split(" ")[1] 
            payload = {"response": v , "tag": k.split(" ")[1] }
            if physicians_questions_responses.empty?
                physicians_questions_responses[k.split(" ")[0]] = [ payload ]
            else
                physicians_questions_responses[k.split(" ")[0]].push(payload) 
            end 
   
        end
        
        physicians_questions_responses.each do |key,value|
            responses = []
            value.each do |v|
                responses.append({
                    "question-id": v[:tag],
                    "value": v[:response]
                })
            end
             data = {"streamName": "com.personicle.individual.datastreams.subjective.physician_questionnaire", "individual_id": "#{session[:oktastate]["uid"]}",
             "source": "Personicle:#{key}", "unit": "", "confidence": 100, "dataPoints":[
              { "timestamp": Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N"),
                "value": responses
              }
            ]
             }

             res = RestClient::Request.execute(:url => ENV['DATASTREAM_UPLOAD'], :payload => data.to_json, :method => :post, headers: {Authorization: "Bearer #{session[:oktastate]['credentials']['token']}", content_type: :json})
                if res.code == 200
                    flash[:success] = "Your responses are recorded"
                    redirect_to pages_dashboard_physician_questions_path(responses_send: true)
                else
                    flash[:success] = "Something went wrong. Please try again"
                    redirect_to pages_dashboard_physician_questions_path(responses_send: false)
                end
            end
      
    end
end
