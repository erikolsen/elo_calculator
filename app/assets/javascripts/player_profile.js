setDailyRatingChangeArrow();

function setDailyRatingChangeArrow() {
  var ratingChange = parseInt($('.daily-rating-change').text())

  if (ratingChange > 0) {
    $('.rating-arrow').addClass('fas fa-sm fa-arrow-up rating-change-up')
  } else if (ratingChange < 0 ){
    $('.rating-arrow').addClass('fas fa-sm fa-arrow-down rating-change-down')

  } else {
    //nothing
  }
};
