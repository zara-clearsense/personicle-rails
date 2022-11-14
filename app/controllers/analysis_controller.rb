class AnalysisController < ApplicationController
    require 'json'
    require 'ostruct'
    require 'date'
    before_action :require_user, :session_active?

    def index
        @response = JSON.parse(File.read('db/scatterplot_e2d.json'))
        puts @response['correlation_result']

        # mean = response.sum(0.0) / response.size
        # puts mean
        # #=> 4.5
        # sum = @response.sum { |element| (element - mean) ** 2 }
        # puts sum
        # #=> 42.0
        # variance = sum / (@response.size - 1)
        # puts variance
        # #=> 6.0
        # standard_deviation = Math.sqrt(variance)
        # puts standard_deviation
        # #=> 2.449489742783178


        # range = mean * 3 * standard_deviation



    end

    def analysis
        @response = JSON.parse(File.read('db/scatterplot_e2d.json'))
        puts @response


    end
end