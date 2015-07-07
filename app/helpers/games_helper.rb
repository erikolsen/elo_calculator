module GamesHelper
  def all_players
    Player.by_name
  end

  def all_players_last_winner_default
    optimized_player_list = all_players.unshift(Game.last.winner).push(Game.last.loser)
    Game.last ? optimized_player_list : all_players
  end
end
