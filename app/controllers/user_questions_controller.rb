class UserQuestionsController < ApplicationController
    before_action :require_user, :session_active?
    def index
        @questions = {}
        @user = User.find_by(user_id: session[:oktastate]['uid'])

        @user.physicians.each do |phy|
            @physician_questions = PhysicianUser.find_by(user_user_id: session[:oktastate]['uid'], physician_user_id: phy.user_id).questions
            
            @questions[[phy.id,phy.name]] = @physician_questions if !@physician_questions.empty?
            
        end

        puts "hello"
        puts @questions
    end

    def responses   

    end
end
