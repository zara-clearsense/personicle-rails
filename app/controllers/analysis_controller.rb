class AnalysisController < ApplicationController
    require 'json'
    require 'ostruct'
    require 'date'
    before_action :require_user, :session_active?

    def index
        @response = JSON.parse(File.read('db/scatterplot_e2d.json'))
        puts @response
        # puts @response['correlation_result']["0"]
        # puts @response['correlation_result']["0"]['data']

        @xarray = []
        @yarray = []
        @response['correlation_result']["2"]['data'].each {|x|
            puts "x values" 
            puts x[0]

            puts "y values"
            puts x[1]

            # Push x and y values into seperate xarray and yarray
            @xarray.push(x[0])
            @yarray.push(x[1])
           
        }
        puts "xarray"
        puts @xarray
        puts "yarray"
        puts @yarray

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

            puts "Find x and index"
            @xarray.each_with_index do | x, index |
                if @xarray.select! {|x| x > range_upper_x || x < range_lower_x } # XArray containing only values in range
                    puts "#{x} is number #{index} in the array"
                    puts "Index: #{index} and Value #{@xarray[index]} Rejected"
                end
                
             end

            # puts "Y-Filtered"
            # puts @yarray.reject {|y| y > range_upper_y || y < range_lower_y }

            # Length of X Array
            puts "Length of X Array - After Filtering"
            puts @xarray.length

            # Length of Y Array
            puts "Length of Y Array = After Filtering"
            puts @yarray.length

        end   

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
end