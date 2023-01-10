class PagesController < ApplicationController
  before_action :require_user, except: [:login,:register, :create_physician_account]
  before_action :is_user_loggedin
  # layout :resolve_layout

  def is_user_loggedin
     if token_is_valid()
      redirect_to pages_dashboard_path
     else
      'authentication'
     end
  end
  # private
  def resolve_layout
    # puts "hello"
    # if session[:oktastate].nil?
    #   render layout: "authentication"
    # elsif !session[:oktastate.nil?] and !session[:oktastate]["physician"]
    #   redirect_to pages_dashboard_path
    # elsif !session[:oktastate.nil?] and session[:oktastate]["physician"]
    #   redirect_to pages_dashboard_physician_path
    # end
    case action_name
    when 'login', 'register'
      if token_is_valid()
        redirect_to 'https://app.personicle.org/pages/dashboard'
      else 
      'authentication'
      end
    else
      #  @profile_image = get_user_profile_image_url()
      # 'dashboard',  locals: { bg_color_class: @profile_image}
      'dashboard'

    end
  end


  def create_physician_account
      # puts params
      # url = "https://dev-01936861.okta.com/api/v1/users?activate=true"
      # data = {
      # "profile": {
      #     "firstName": params[:first_name],
      #     "lastName": params[:last_name],
      #     "email": params[:email],
      #     "login": params[:email],
      #     },
      #     "groupIds": [
      #     ]
      # }
      # begin
      #   res = RestClient::Request.execute(:url => url,  :payload => data.to_json, headers: {Authorization: "", :content_type =>'application/json'}, :method => :post)
      # rescue RestClient::ExceptionWithResponse => e
      #   return render  layout: "authentication", locals: {status_msg: "An account with that email already exists."}
      # end
      
      # if res.code == 200
      #   # redirect_to root_path(physician_activation: "success", physician_email: params[:email])
      #   render  layout: "authentication", locals: {status_msg: "An activation link has been sent to #{params[:email]}"}
      #     # respond_to do |format|
      #     #     format.html {render 'pages/login.html.erb', locals: { status_msg: "An activation link has been sent to #{params[:email]}"} }
      #     # end
      # end

  end
  # def resolve_layout
  #   case action_name
  #   when 'login', 'register'
  #     # 'authentication'
    

  #   else
  #     'dashboard'
  #   end
  # end
end
