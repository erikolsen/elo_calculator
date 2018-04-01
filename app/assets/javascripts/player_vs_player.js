$(document).on('turbolinks:load', function() {
  $(function() {
    var primaryId = $('#player-vs-player').data('primary-id');
    var secondaryId = $('#player-vs-player').data('secondary-id');
    //var startDate = $('#player-vs-player').data('start-date');
    //var endDate = $('#player-vs-player').data('end-date');
    if(primaryId && secondaryId) {
      $.getJSON('/player-vs-player?primary='+primaryId+'&secondary='+secondaryId)
        .error(function() {
          console.log('could not get player stats for: ' + primaryId);
        })
      .done(function(data) {
        var ctx = $('#player-vs-player');
        var chart = new Chart(ctx, {
          type: 'bar',
          data: {
            labels: xAxisData(data),
            datasets: [
              {
                type: 'bar',
                label: 'Games Won',
                stack: 1,
                data: yAxisDataWon(data),
                backgroundColor: '#007C3F',
              },
              {
                type: 'bar',
                label: 'Games Lost',
                stack: 1,
                data: yAxisDataLost(data),
                backgroundColor: '#B31313',
              }
            ]
          },
          options: {
            responsive: true,
            maintainAspectRatio: true,
            scales: {
              yAxis: [{type: 'bar', stacked: true}],
              xAxis: [{
                type: 'time',
                time: {
                  unit: 'll'
                },
                stacked: true
              }]
            }
          }
        });
      });

      function formatDate(s) {
        var date = new Date(s);
        //return (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear()
        return (date.getMonth() + 1) + '/' + date.getFullYear()
      }

      function xAxisData(data) {
        return $.map(data, function(datum) {
          return formatDate(datum[0].x);
        });
      }

      function yAxisDataWon(data) {
        return $.map(data, function(datum) {
          return datum[1].y;
        });
      }
      function yAxisDataLost(data) {
        return $.map(data, function(datum) {
          return datum[0].y;
        });
      }
    }
  });
});
