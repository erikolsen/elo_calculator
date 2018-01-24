function swap(){
  var oldWinner = $('#game_winner_id').val();
  var oldLoser = $('#game_loser_id').val();
  $('#game_winner_id').val(oldLoser);
  $('#game_loser_id').val(oldWinner);
};
