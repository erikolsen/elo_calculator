$(document).on('turbolinks:load', function() {
  $(function() {
    var playerId = $('#rating-over-time-graph').data('player-id');
    var limit = $('#rating-over-time-graph').data('limit');
    if(playerId) {
      $.getJSON('/player_stats/' + playerId+'?limit='+limit)
        .error(function() {
          console.log('could not get player stats for: ' + playerId);
        })
      .done(function(data) {
        var ctx = $('#rating-over-time-graph');
        var chart = new Chart(ctx, {
          type: 'line',
          data: {
            labels: xAxisData(data),
            datasets: [
            {
              label: 'Rating Over Time',
              lineTension: 0,
              data: yAxisData(data),
              backgroundColor: [
                'rgba(0, 153, 255, 0.2)'
              ],
              borderColor: [
                'rgba(0, 153, 255, 1)'
              ],
              borderWidth: 1
            }
            ]
          },
          options: {
            responsive: true,
            maintainAspectRatio: true,
            scales: {
              xAxis: [{
                type: 'time',
                time: {
                  unit: 'll'
                }
              }]
            }
          }
        });
      });

      function formatDate(s) {
        var date = new Date(s);
        return (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear().toString().substr(-2);
      }

      function xAxisData(data) {
        return $.map(data, function(datum) {
          return formatDate(datum.x);
        });
      }

      function yAxisData(data) {
        return $.map(data, function(datum) {
          return datum.y;
        });
      }
    }
  });
});
