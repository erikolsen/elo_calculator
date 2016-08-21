$(function() {
  var playerId = $('#rating-over-time-graph').data('player-id');
  $.getJSON('/player_stats/' + playerId)
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
              label: 'Rating',
              lineTension: 0,
              data: yAxisData(data)
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
      return (date.getMonth() + 1) + '/' + date.getDate() + ' ' + date.getHours() + ':' + date.getMinutes();
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
});
