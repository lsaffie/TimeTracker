%h1 Two-week Trend
%div#chart

=render(:partial => 'chart.html.haml')
:javascript
  google.load("visualization", "1", {packages:["corechart"]});
        google.setOnLoadCallback(drawChart);
        function drawChart() {
          var data = google.visualization.arrayToDataTable(
            #{@data_array}
          );

          var options = {
            title: '14-day trend'
          };

          var chart = new google.visualization.LineChart(document.getElementById('chart'));
          chart.draw(data, options);
        }
