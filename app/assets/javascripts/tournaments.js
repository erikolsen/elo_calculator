// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$('#datepicker').datepicker({autosize: true, dateFormat: 'yy-mm-dd'});
$('#datepicker').on('click', setCalendarWidth);

function setCalendarWidth() {
  var width = $('#datepicker').width();
  var paddingEstimate = 18
  $('#ui-datepicker-div').css('width', width+paddingEstimate);
};

function populateClubMembers(){
  club_slug = $('.club-dropdown option:selected').val() || 'all_players'
  url = '/clubs/' + club_slug + '/memberships'
  $.getJSON( url, function( data ) {
    var items = [];
    $.each( data, function( key, val ) {
      label =  "<label class='button secondary expanded' for='tournament_players_" + key + "'>" + val.name + "</label>"
      input = "<input type='checkbox' name='tournament[players][]' id='tournament_players_" + key + "' value='" + val.id + "'>"
      items.push(input + label);
    });
    $('.player-checkboxes').html(items);
  });

};
