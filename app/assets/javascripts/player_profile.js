$(document).on('turbolinks:load', function() {
  setDailyRatingChangeArrow();
});

function setDailyRatingChangeArrow() {
  var ratingChange = parseInt($('.daily-rating-change').text())

  if (ratingChange > 0) {
    $('.daily-rating-change').css('border', 'solid green 4px')
  } else if (ratingChange < 0 ){
    $('.daily-rating-change').css('border', 'solid red 4px')
  } else {
    //nothing
  }
};
