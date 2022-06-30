import React, { useEffect, useState } from "react";
import { Spinner } from "react-bootstrap";
import sample_steps from "../sample_data/sample_steps"
import useGoogleCharts from './useGoogleCharts'

function MobilityChart ({userSummary}) {
    console.log(userSummary)
    const google = useGoogleCharts()
    const [chart, setChart] = useState(null);
    const [dimensions, setDimensions] = useState({ 
      height: 0,
      width: 0
    })
    useEffect(() => {
        if (google && !chart) {

        let steps = sample_steps["sample_steps"];
        console.log("We are using JavaScript");

        // Convert Date to Standard Format (Compattible with Different Browsers)
        function dateToStandardFormat(date){
            var values = date.split(/[^0-9]/);
            var year = parseInt(values[0]);
            var month = parseInt(values[1]) - 1;
            var day = parseInt(values[2]);
            var hours = parseInt(values[3]);
            var minutes = parseInt(values[4]);
            var seconds = parseInt(values[5]);
            var formattedDate =  new Date(year, month, day, hours, minutes, seconds);
            console.log(formattedDate)
            return formattedDate;
        }

        function findMinuteOfDay(date) {
            var values = date.split(/[^0-9]/);
            var minute = parseInt(values[4]);
            var hour = parseInt(values[3]);
            var minuteOfDay = hour * 60 + minute;
            return minuteOfDay;
        }
    
        // Create the data table. 
        // if (google && !chart) {
            var totalSteps = {}; // total steps at each minute
            var uniqueMinutes = new Set();
            var totalCount = {}; // total count of values we get for each minute (for average, n)

            steps.forEach(event => {
                var minuteOfDay = findMinuteOfDay(event.dateTime);
                uniqueMinutes = uniqueMinutes.add(minuteOfDay); // unique Set of minutes for different days 

                if (minuteOfDay in totalSteps) {
                    if(event.value != undefined) {
                        totalSteps[minuteOfDay] = totalSteps[minuteOfDay] + parseInt(event.value);
                        totalCount[minuteOfDay] = totalCount[minuteOfDay] + 1;
                    }
                }
                else { 
                    if(event.value != undefined){
                        totalSteps[minuteOfDay] = parseInt(event.value);
                        totalCount[minuteOfDay] = 1;
                    } 
                } 
            }
             
        );

            var data = new google.visualization.DataTable();
            data.addColumn({ type: 'number', id: 'Minute Of Day', label: 'Minute Of Day'});
            data.addColumn( {type: 'number', id: 'Overall Steps Trend', label: 'Overall Steps Trend'} )
            // data.addColumn( {type: 'string', id: 'Trend', label: 'Trend'} ) 
            
            for (const minuteOfDay in totalSteps) {
                var dataRow = [];
                console.log(typeof(minuteOfDay));
                console.log(totalSteps[minuteOfDay]/totalCount[minuteOfDay]);
                console.log(minuteOfDay);
                console.log(totalSteps[minuteOfDay], totalCount[minuteOfDay])

                dataRow.push(parseInt(minuteOfDay));
                dataRow.push(totalSteps[minuteOfDay]/totalCount[minuteOfDay]);
                // dataRow.push('Overall Average Mobility')
                data.addRow(dataRow);
            }

            // Display time on x-axis in options (convert back to time from minutes)
            function toHoursAndMinutes(minuteOfDay) {
                const minutes = minuteOfDay % 60;
                const hours = Math.floor(minuteOfDay / 60);
                console.log(minuteOfDay, hours, minutes)
                console.log(minuteOfDay, hours * 60 + minutes)
                return `${padTo2Digits(hours)}:${padTo2Digits(minutes)}`;
              }
              
              function padTo2Digits(num) {
                return num.toString().padStart(2, '0');
              }
            // Dispay total steps and total count for last week worth of data
            
        var options = {
            chart: {
            title: 'Mobility Chart',
            subtitle: 'How much movement a user has per day'
            },
            width: 1000,
            height: 500,
            vAxis: {title: 'Total Steps'},
            hAxis: 
                {title: 'Minute Of Day',
                showTextEvery: 5},
            legend: {position: 'left'},
            seriesType: 'line'
        };

        var comboChartOptions = {
            chart: {
            title: 'Mobility Chart',
            subtitle: 'How much movement a user has per day'
            },
            width: 1000,
            height: 500,
            vAxis: {title: 'Total Steps'},
            hAxis: 
                {title: 'Minute Of Day',
                showTextEvery: 5},
            legend: {position: 'left'},
            seriesType: 'line'
        };


        var chart = new google.charts.Line(document.getElementById('line_top_x'));
        chart.draw(data, google.charts.Line.convertOptions(options));
        
        function resize () {
            //   console.log("called resize");
            //   const chart = new google.visualization.ComboChart(document.getElementById('combo_chart_div'));
        
              comboChartOptions.width = 0.5 * window.innerWidth;
              comboChartOptions.height = .4 * window.innerHeight;
            //   columnFilter.draw(data, options);
            chart.draw(data, google.charts.Line.convertOptions(options));
            }
            window.onload = resize;
            window.onresize = resize;
        
    }
}, [google, chart]);

return (
    <>
      {!google && <Spinner />}
      <div id="mobility_div">
        <div id="line_top_x" className={!google ? 'd-none' : ''}/>
      </div>
    </>
    )
}

export default MobilityChart