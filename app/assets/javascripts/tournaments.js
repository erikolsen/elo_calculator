// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).on('page:change', function () {
  $('.datepicker').datepicker({autosize: true});
  $('.datepicker').on('focus', setCalendarWidth);
});

function setCalendarWidth() {
  var width = $('.datepicker').width();
  var paddingEstimate = 18
  $('#ui-datepicker-div').css('width', width+paddingEstimate);
};
