
import { useEffect, useState } from "react";

function useGoogleCharts () {
  const [google, setGoogle] = useState(null);
  
  useEffect(() => {
    if (!google) {
      const head = document.head;
      let script = document.getElementById('googleChartsScript');
      
        script = document.createElement('script');
        script.src = 'https://www.gstatic.com/charts/loader.js';
        script.id = 'googleChartsScript';

          if (window.google || window.google.charts) {
            window.google.charts.load('current', {'packages':['timeline', 'controls','corechart', 'line']});
            
            window.google.charts.setOnLoadCallback(() => setGoogle(window.google));
          
          }
        
        head.appendChild(script);
     
    }

    return () => {
      let script = document.getElementById('googleChartsScript');
      
    }
  }, [google]);

  return google;
}

export default useGoogleCharts;