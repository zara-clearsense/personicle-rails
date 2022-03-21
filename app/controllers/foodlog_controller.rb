class FoodlogController < ApplicationController
    require 'json'
    require 'ostruct'
    require 'date'
    before_action :require_user
    
    def index
        
    end
    
    def get_edamam_data
        required = [:q, :mealType, :cuisineType]
      
        form_complete = true
        required.each do |k|
            if params.has_key?(k) and not params[k].blank?
            else
                form_complete = false
            end
        end
        if form_complete
            form_status_msg = 'Fetching recipes!'
            url = "https://api.edamam.com/search?q=#{params[:q]}&mealType=#{params[:mealType]}&cuisinetype=#{params[:cuisineType]}&app_id=0254fb82&app_key=4856fb6baec97ae4ba40af3dc73edef8&to=100"
            res = RestClient::Request.execute(:url => url, :method => :get)
            response = JSON.parse(res,object_class: OpenStruct)
            
          else
            form_status_msg = 'Please fill out all fields'
        end

        if form_complete
            respond_to do |format|
                format.html {render :recipes, locals: { status_msg: form_status_msg, feedback: params, recipes: response.hits } }
                # redirect_to pages_recipes_path, recipes: response.hits
            end
        else 
            respond_to do |format|
                format.html {render :index, locals: { status_msg: form_status_msg, feedback: params} }
            end
        end
        
    end
  end
  