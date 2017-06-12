// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$('#datepicker').datepicker({autosize: true, dateFormat: 'yy-mm-dd'});
$('#datepicker').on('click', setCalendarWidth);

function setCalendarWidth() {
  var width = $('#datepicker').width();
  var paddingEstimate = 18
  $('#ui-datepicker-div').css('width', width+paddingEstimate);
};
