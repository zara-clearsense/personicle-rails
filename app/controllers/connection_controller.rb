class ConnectionController < ApplicationController
  
    before_action :require_user, :session_active?, :get_user_notifications
    
    def index

      @user = User.find_by(user_id: session[:oktastate]['uid'])
      puts @user

      @external_connections = ExternalConnections.where(userId: session[:oktastate]['uid'])
      puts @external_connections

      @service_status = {}
      @possible_services = ["fitbit", "google-fit", "oura"]
      puts "Get Status for Each Connection"
      @external_connections.each do |connection|
        @service = connection.service
        @status = connection.status
        puts "Service: #{@service}"
        puts "Status: #{@status}"

        @service_status[@service] = @status
      
        if @status.to_s == "expired"
          puts "Reconnect the service - Red rectangle"
        elsif @status.to_s == "connected"
          puts "Service Connected - Green Rectangle"
        end
      end

      @not_included = {}
      puts "Check if @external_connections does not include row for any service in @possible_services"
        @possible_services.each do |service|
          unless @external_connections.any? { |connection| connection.service == service }
            puts "#{service} not connected - Grey rectangle"
            @not_included[service] = true
            puts @not_included
          end
        end
        puts ""
        puts @service_status

        @service_status.each_with_index do |kv, i| 
        # Debugging statements
        puts "Debugging Statements"
      puts "index: #{i}" 
      puts "key-value pair: #{kv}"
      puts "@service: #{@service_status.keys[i] == "fitbit"}"
      puts "@status: #{@service_status.values[i] == "connected"}"
      puts "@not_included: #{@not_included}"
        end
  end
end