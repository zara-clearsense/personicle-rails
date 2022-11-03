class AnalysisController < ApplicationController
    require 'json'
    require 'ostruct'
    require 'date'
    before_action :require_user, :session_active?

    def index
        @response = JSON.parse(File.read('db/scatterplot_e2d.json'))
        puts @response
    end

    def analysis
        # @response = JSON.parse(File.read('/root/frontend-rubyonrails/personicle-rails/db/scatterplot_e2d.json'))
        # puts @response
    end
end