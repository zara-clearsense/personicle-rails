// import React, { useEffect, useState } from "react";
// import { Spinner } from "react-bootstrap";
// import sample_events from "../sample_data/sample_events"
// import useGoogleCharts from './useGoogleCharts'

// function MobilityChart ({userSummary}) {
//     console.log(userSummary)
//     const google = useGoogleCharts()
//     const [chart, setChart] = useState(null);
//     const [dimensions, setDimensions] = useState({ 
//       height: 0,
//       width: 0
//     })
//     useEffect(() => {

//         let steps = sample_steps["sample_steps"];

//         // Convert Date to Standard Format (Compattible with Different Browsers)
//         function dateToStandardFormat(date){
//             var values = date.split(/[^0-9]/),
//             year = parseInt(values[0]),
//             month = parseInt(values[1]) - 1,
//             day = parseInt(values[2]),
//             hours = parseInt(values[3]),
//             minutes = parseInt(values[4]),
//             seconds = parseInt(values[5])
//             var formattedDate =  new Date(year, month, day, hours, minutes, seconds)
//             console.log(formattedDate)
//             return formattedDate;
//         }
    
//         // Create the data table. 
//         if (google && !chart) {
//             var day = {}; // unique set of days (non-recurring)
//             var mobilityScore = {}
//             var data = new google.visualization.DataTable();
//             data.addColumn('number', 'Minute');
//             data.addColumn('number', 'Mobility Score Per Minute');
//             //data.addColumn('number', 'Average Mobility Score over Month');

//             steps.forEach(event => {
//                 {
//                     day = 
//                     data.addRow([dateToStandardFormat(steps.dateTime), steps.value]);
//             }});

        
//         var options = {
//             chart: {
//             title: 'Mobility Chart',
//             subtitle: 'How much movement a user has per day'
//             },
//             width: 900,
//             height: 500,
//             axes: {
//             x: {
//                 0: {side: 'top'}
//             }
//             }
//         };

//         var chart = new google.charts.Line(document.getElementById('line_top_x'));

//         chart.draw(data, google.charts.Line.convertOptions(options));
//         }
//     }
// }
    
