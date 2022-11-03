import React, { useEffect, useState } from "react";
import { Spinner } from "react-bootstrap";
import useGoogleCharts from './useGoogleCharts'

function AnalysisChart({userSummary}) {
    // console.log(userSummary)
    const google = useGoogleCharts()
    const [chart, setChart] = useState(null);
    const [dimensions, setDimensions] = useState({ 
      height: 0,
      width: 0
    })
    useEffect(() => {
        if (google && !chart) {


        console.log("We are using JavaScript");

     
            var data = google.visualization.arrayToDataTable([
              ['Age', 'Weight'],
              [ 8,      12],
              [ 4,      5.5],
              [ 11,     14],
              [ 4,      5],
              [ 3,      3.5],
              [ 6.5,    7]
            ]);
    
            var options = {
              title: 'Age vs. Weight comparison',
              hAxis: {title: 'Age', minValue: 0, maxValue: 15},
              vAxis: {title: 'Weight', minValue: 0, maxValue: 15},
              legend: 'none'
            };
    
            var chart = new google.visualization.ScatterChart(document.getElementById('chart_div'));
    
            chart.draw(data, options);
        
    }
<body>
    <div id="chart_div" style="width: 900px; height: 500px;"></div>
</body>
}


 


)}

export default AnalysisChart