class ChartsController < ApplicationController
require 'json'
require 'ostruct'
require 'date'
before_action :require_user, :session_active?, :get_user_notifications

    def user_mobility
        url = 'http://localhost:3000/steps.json'
        #logger.info 'url: ' + url
        puts session[:oktastate]
        res = RestClient::Request.execute(:url => url, headers: {Authorization: "Bearer #{session[:oktastate]['credentials']['token']} "}, :method => :get, :verify_ssl => false)
        #puts res
        if res
            #hash = JSON.parse(res)
            #res.strip("\"dateTime": \"")
            #res.gsub!(/^*("\"dateTime: \"")*$/, '')

            #res.strip(", \"value\"")
            #res.gsub!(/^*(", \"value\"")*$/, '')


            #str = "{\"dateTime\": \"2020-03-31 23:59:00\", \"value\": \"0\"}"
            #str.gsub(/v/, '*')
            #str.strip!


            #logger.info "res" + str
            @dashboards = JSON.parse(res)
            
        end

        # logger.info "hi friends" + "#{@dashboards.flat_map { |role| role["dateTime"].tr('"', '') + ' : ' + role["value"].tr('"', '') }}"
        
        #@copy1 = @dashboards.map(&:values).select {|dateTime, values| values["dateTime"] != 0}
        #logger.info "#{@copy1.to_json}"

        logger.info "#{@dashboards}"
        #logger.info 'Chart Controller: ' + "#{@dashboards[0]}"
        # render json: {"dateTime": "2020-03-31 23:59:00", "value": "0"}
        # render json: @dashboards#.group_by_day(:created_at).count
        render json: @dashboards#.group_by_day(:created_at).count
        #render json: MultiJson.dump(@dashboards)
        #render json: @dashboards.flat_map { |role| role["dateTime"] + ' : ' + role["value"] }

    end
end