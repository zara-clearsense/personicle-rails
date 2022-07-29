class QuestionController < ApplicationController
    before_action :require_user, :session_active?, :is_user_physician?
    def index
        
    end
    def delete_questions
        puts params
    end
    def create
        @physician = Physician.find_by(user_id: session[:oktastate]['uid'])
        # puts params.except(:authenticity_token, :action, :controller)
        patient_id  = params[:patient_id] 
        new_question = params[:questions]
        existing_questions = params[:selected_questions].to_a
        options = params[:options].to_a
        tag = params[:tag]
        @physician_patient = PhysicianUser.find_by(user_user_id: patient_id, physician_user_id: session[:oktastate]['uid'] )

        delete_questions = params[:delete_selected_questions]
        

        if !delete_questions.nil?
            updated_questions = @physician_patient.questions['questions'].filter {|q| delete_questions.include?(q['question']) == false}
            puts "hello"
            puts updated_questions.class
            @physician_patient.questions['questions'] = updated_questions

            @physician_patient.save
          
        end

        if !new_question.blank?
        payload = {
            "question": new_question,
            "tag": tag.gsub(/\s+/, ""),
            "options": options,
            "response_type": params[:response_type]
        }
        if @physician.questions.empty?
            @physician.questions['questions'] = [payload]
        else
            tag_exists = @physician.questions['questions'].filter {|q| q['tag'] == tag}

            if tag_exists.empty? #unique tag provided
                @physician.questions['questions'].push(payload)
            else
                flash[:warning] = "Tag already exists. Please provide a different Tag."
                return redirect_to pages_dashboard_physician_get_user_data_path(data_for_user: patient_id)
            end
        end

            
            if @physician_patient.questions.empty?
                @physician_patient.questions['questions'] = [payload]
            else
                @physician_patient.questions['questions'].push(payload)
            end
            @physician.save
            @physician_patient.save
        end

        if !existing_questions.blank?
            get_exisitng_question_obj = []
            existing_questions.each do |eq|
                get_exisitng_question_obj.push(@physician.questions['questions'].filter {|q| q['question'] == eq}.first)
            end
       
            if @physician_patient.questions.empty?
                @physician_patient.questions['questions'] = get_exisitng_question_obj
            else
                get_exisitng_question_obj.each do |ques|
                    tag_exists = @physician_patient.questions['questions'].filter {|q| q['tag'] == ques['tag']}
                    if !tag_exists.empty?
                        puts "question already exits"
                        next
                    end
                     @physician_patient.questions['questions'].push(ques)
                end
            end
            @physician_patient.save
        end
        
        redirect_to pages_dashboard_physician_get_user_data_path(data_for_user: patient_id)
    end

    def is_user_physician?
        if !session[:oktastate]["physician"]
            return redirect_to pages_dashboard_path
        end
    end
end