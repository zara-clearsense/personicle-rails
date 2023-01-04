class AnalysisController < ApplicationController
    require 'json'
    require 'ostruct'
    require 'date'
    require 'csv'
    before_action :require_user, :session_active?

    def index
        puts params
        if(params.has_key?(:selected_analysis_id))
            puts "Selected Analysis ID found in Parameters"
            puts params[:selected_analysis_id]
        else
            puts "Not found"
        end
        @response = JSON.parse(File.read('db/scatterplot_e2d.json'))
        # puts @response
        # puts @response['correlation_result']["0"]
        # puts @response['correlation_result']["0"]['data']
        
        @xarray = []
        @yarray = []
        @response['correlation_result']["2"]['data'].each {|x|
            # puts "x values" 
            # puts x[0]

            # puts "y values"
            # puts x[1]

            # Push x and y values into seperate xarray and yarray
            @xarray.push(x[0])
            @yarray.push(x[1])
           
        }
        puts "xarray"
        # puts @xarray
        puts "yarray"
        # puts @yarray

        # Calculate mean for x and y arrays
        puts "Mean X"
        mean_x = @xarray.sum(0.0) / @xarray.size
        puts mean_x

        puts "Mean Y"
        mean_y = @yarray.sum(0.0) / @yarray.size
        puts mean_y
    
        # Calculate sum for x and y arrays
        puts "Sum X"
        sum_x = @xarray.sum { |element| (element - mean_x) ** 2 }
        puts sum_x

        puts "Sum Y"
        sum_y = @yarray.sum { |element| (element - mean_y) ** 2 }
        puts sum_y
     
        # Calculate variance for x and y arrays
        puts "Variance X"
        variance_x = sum_x / (@xarray.size - 1)
        puts variance_x

        puts "Variance Y"
        variance_y = sum_y / (@yarray.size - 1)
        puts variance_y

        # Calculate standard deviation for x and y arrays
        puts "Standard Deviation X"
        standard_deviation_x = Math.sqrt(variance_x)
        puts standard_deviation_x

        puts "Standard Deviation Y"
        standard_deviation_y = Math.sqrt(variance_y)
        puts standard_deviation_y

        # If xarray or yarray is empty, no data to plot
        # Calculate upper and lower ranges
        # Plot all values inside this range and don't plot any outside the range 
        if @xarray.empty? || @yarray.empty? 
            puts "X Array or Y Array are Empty"
        else
            puts "Lower Range X"
            range_lower_x = percentile(@xarray, 0.025)
            puts range_lower_x
            puts "Upper Range X - 97th Percentile"
            range_upper_x = percentile(@xarray, 0.975)
            puts range_upper_x

            puts "Lower Range Y"
            range_lower_y = percentile(@yarray, 0.025)
            puts range_lower_y
            puts "Upper Range Y"
            range_upper_y = percentile(@yarray, 0.975)
            puts range_upper_y

            # puts "95th Percentile"
            # puts "Upper Range X"
            # range_upper_x = percentile(@xarray, 0.95)
            # puts range_upper_x

            # puts "50th Percentile"
            # puts "Upper Range X"
            # range_upper_x = percentile(@xarray, 0.50)
            # puts range_upper_x

            # Filter
            puts "X-Filtered"
            # puts @xarray.select! {|x| x > range_upper_x || x < range_lower_x } # Values removed from X

            save_index_x = []
            save_index_y = []
            combined_index = []
            puts "Find x and index"
            @xarray.each_with_index do | x, index |
                if (x > range_upper_x || x < range_lower_x)
                    # puts "#{x} is number #{index} in the array"
                    # puts "Index: #{index} and Value #{@xarray[index]} Rejected"
                else
                    # Store list of indices we want to select
                    save_index_x.push(index)
                end
            end
                
            @yarray.each_with_index do | y, index |
                if (@yarray[index] > range_upper_y || @yarray[index] < range_lower_y)
                    # puts "#{y} is number #{index} in the array"
                # Use index to access corresponding y value in array
                    # puts "#{@yarray[index]} is number #{index} in the array"
                    # puts "Index: #{index} and Value #{@yarray[index]} Rejected"
                else
                    save_index_y.push(index)
                end
                # @xarray.reject {|x| x > range_upper_x || x < range_lower_x }
                    # if @xarray.select! {|x| x > range_upper_x || x < range_lower_x } # XArray containing only values in range        
            end 

            # Length of X Array
            puts "Length of X Array - After Filtering"
            # puts @xarray.length

            # Length of Y Array
            puts "Length of Y Array = After Filtering"
            # puts @yarray.length

            puts "Saved Indexes with Filtered Values Removed"
            # puts save_index_x

            puts "Saved Y Indexes with Filtered Values Removed"
            # puts save_index_y

            puts "Combined Indices"
            combined_index = save_index_x.intersection(save_index_y)
            # puts combined_index

        end

        # Populate filtered values with array of (x,y) values
        filtered_values = []
        for i in combined_index
            # puts "combined"
            # puts i
            filtered_values.push([@xarray[i],@yarray[i]])
        end

        puts "Filtered Values"
        # puts filtered_values
          
        # Push filtered_values into @response which will be fed to the view
        @response['correlation_result']["2"]["data"].replace(filtered_values)
        puts "Response After Anomaly Removal - Replacing Data with Filtered Values in Position 2"
        puts @response

        # Make view expect only data from one user
        @send =  @response['correlation_result']["2"]

        # Parse CSV file
        # puts "Parsed CSV File"
        # @table = CSV.parse(File.read("/root/frontend-rubyonrails/personicle-rails/db/sample-analysis.csv"), headers: true)
        # puts @table

            # Query Unique Analysis ID by Specified Unique Analysis ID
    # puts "User Created Analysis"
    # # user_id = UserCreatedAnalysis.find_by(user_id: "test_user")
    # unique_analysis_id = UserCreatedAnalysis.find_by(unique_analysis_id: "cae1ec8f-e648-4993-ad80-f63f813a0ddc")
    # # puts user_id
    # puts unique_analysis_id

    # Query User Created Analysis for Test User
    @user_created_analyses = UserCreatedAnalysis.where("user_id = 'test_user'")
    puts @user_created_analyses
    @user_created_analyses.each do |analysis|
        puts "User ID Loop"
        puts analysis.user_id

        puts "Unique Analysis ID"
        puts analysis.unique_analysis_id

        puts "Anchor"
        puts analysis.anchor

        puts "Antecedent Name Loop"
        puts analysis.antecedent_name

        puts "Antedent Table"
        puts analysis.antecedent_table

        puts "Antecedent Parameter"
        puts analysis.antecedent_parameter

        puts "Consequent Name"
        puts analysis.consequent_name

        puts "Consequent Table"
        puts analysis.consequent_table

        puts "Consequent Parameter"
        puts analysis.consequent_parameter

        puts "Aggregate Function"
        puts analysis.aggregate_function

        puts "Antecedent Type"
        puts analysis.antecedent_type

        puts "Consequent Type"
        puts analysis.consequent_type

        puts "Consequent Interval"
        puts analysis.consequent_interval

        puts "Antecendent Interval"
        puts analysis.antecedent_interval

        puts "Query Interval"
        puts analysis.query_interval
        puts "--------------"
    end
            # puts "Antecedent Name"
            # puts unique_analysis_id.antecedent_name   

    end

    def percentile(values, percentile)
        values_sorted = values.sort
        k = (percentile*(values_sorted.length-1)+1).floor - 1
        f = (percentile*(values_sorted.length-1)+1).modulo(1)
        
        return values_sorted[k] + (f * (values_sorted[k+1] - values_sorted[k]))
    end

    def analysis
        @response = JSON.parse(File.read('db/scatterplot_e2d.json'))
        puts @response
    end

    def select_event  
        # Get Updated Event
        puts "Print selected event"
        selected = params[:selected]
        puts params[:selected].class
        puts selected

        # Pass selected analysis ID and make a call to main analysis page and pass as parameter
        redirect_to pages_analysis_path(refresh:"hard_refresh", selected_analysis_id: selected)
    end

   

end