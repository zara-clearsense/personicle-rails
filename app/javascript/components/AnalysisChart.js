import React, { useEffect, useState } from "react";
import { Spinner } from "react-bootstrap";
import useGoogleCharts from "./useGoogleCharts";

function AnalysisChart({ userSummary }) {
  // console.log(userSummary)
  const google = useGoogleCharts();
  const [chart, setChart] = useState(null);
  const [dimensions, setDimensions] = useState({
    height: 0,
    width: 0,
  });
  useEffect(() => {
    if (google) {
      console.log("We are using JavaScript");
      
      // console.log(userSummary['correlation_result']);
      var data = new google.visualization.DataTable();        
      data.addColumn({ type: 'number', id: userSummary['XAxis']['Measure'] });
      data.addColumn({ type: 'number', id: userSummary['YAxis']['Measure'] });
      data.addColumn({ type: 'string', role: 'tooltip'});
      
    // console.log(Object.keys(userSummary['correlation_result']).length);
    
   
    // for (var i=0; i < Object.keys(userSummary['correlation_result']).length; i++) {
        console.log(userSummary['data']);
        for (var j=0; j < userSummary['data'].length; j++) {
        // data.addRow(userSummary['correlation_result'][i]['data']);
        console.log(userSummary['data'][j]);
        console.log(typeof userSummary['data'][j][0]);
        console.log(typeof userSummary['data'][j][1]);
        var datapoint = [...userSummary['data'][j],`${userSummary['data'][j][0]} ${userSummary['XAxis']['Measure']}, ${userSummary['data'][j][1]} ${userSummary['YAxis']['unit']}`];
        data.addRow(datapoint);
        }
        
      var options = {
        title: "Total Calories vs. Sleep Duration",
        hAxis: { title: userSummary['XAxis']['Measure'] + " (" + userSummary['XAxis']['unit'] + ")"}, units: userSummary['XAxis']['unit'], minValue: 0, maxValue: 15 ,
        vAxis: { title: userSummary['YAxis']['Measure'] + " (" + userSummary['YAxis']['unit'] + ")" }, units: userSummary['YAxis']['unit'], minValue: 0, maxValue: 15 ,
        legend: "none",
        trendlines: { 0: {} },    // Draw a trendline for data series 0.
        height: '100%',
        width: '100%'
      };

      // Create a Scatterplot, passing some options
      var scatterPlotOptions = {
        width: '100%',
        height: '40%',
        legend: 'none'
    };

    // Drag and Select to Zoom Functionality - Right Click to Return to Original Chart
    options.explorer = {
      actions: ['dragToZoom', 'rightClickToReset']
    }

      var scatterPlot = new google.visualization.ScatterChart(
          document.getElementById("chart_div")
  );

      // Instantiate and draw our dashboard and chart, passing in some options.
      var dashboard = new google.visualization.Dashboard(document.getElementById('chart_div'));
      scatterPlot.draw(data, options);

      function resize () {
        const chart = new google.visualization.ScatterChart(document.getElementById('chart_div'));
        scatterPlotOptions.width = 1.0 * window.innerWidth;
        //barChartOptions.height = .4 * window.innerHeight;
        scatterPlot.draw(data, options);
      }

      window.onload = resize;
      window.onresize = resize;
    }

  }, [google, chart]);
  return (
    <>
      {!google && <Spinner />}
      <div id="analysis_chart_dashboard">
        <div id="chart_div"></div>
      </div>
    </>
  );
}

export default AnalysisChart;
