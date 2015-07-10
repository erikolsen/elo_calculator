module GamesHelper
  def all_players
    Player.by_name
  end

  def last_winner_id
    Game.last.winner_id if Game.last
  end

  def optimized_player_list
    list = all_players.push Player.last_loser
    Game.last ? list : all_players
  end
end
