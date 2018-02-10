// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/widgets/datepicker
//= require foundation
//= require game_entry
//= require google_analytics
//= require tournaments
//= require player_profile
//= require Chart
//= require turbolinks
//= require_tree .

$(document).on('turbolinks:load', function() {
  $(function(){
    $('.top-bar').foundation();
    // This is to avoid a flash of unstyled content when
    // foundation is initialized
    $('ul').removeClass('hamburger-hidden');
  });
});

'<input type="radio" value="19" name="games[1]" id="games_1_19">'
'<label class="button secondary expanded" id="label_games_1_19" for="games_1_19">Yoda</label>'
function populateMatchups(array){
  var items = [];
  $.each(array, function( key, val ) {
    label = '<label class="button secondary expanded" id="label_games_1_19" for="games_1_19">Yoda</label>'
    input = '<input type="radio" value="19" name="games[1]" id="games_1_19">'
    items.push(input + label);
  });
  $('#matchupForm').html(items);
};
