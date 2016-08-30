$(document).on('page:change', function () {
  $("#tabs").tabs({
    active: localStorage.getItem("currentTabIndex"),
    activate: function(event, ui) {
      localStorage.setItem("currentTabIndex", ui.newTab[0].dataset["tabIndex"]);
    }
  });
});

setDailyRatingChangeArrow();

function setDailyRatingChangeArrow() {
  var ratingChange = parseInt($('.daily-rating-change').text())

  if (ratingChange > 0) {
    $('.rating-arrow').addClass('fi-arrow-up rating-change-up')
  } else if (ratingChange < 0 ){
    $('.rating-arrow').addClass('fi-arrow-down rating-change-down')

  } else {
    //nothing
  }
};
