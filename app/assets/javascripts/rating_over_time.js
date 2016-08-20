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
          labels: ['Player'],
          datasets: [
            {
              label: 'Rating',
              data: data
            }
          ]
        }
      });
    });
});
