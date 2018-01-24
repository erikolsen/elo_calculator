module GamesHelper
  def all_players
    Player.by_name
  end

  def last_ten_games
    Game.last(10).reverse
  end

  def last_winner_id
    Game.last.winner_id if Game.last
  end

  def last_loser_id
    Game.last.loser_id if Game.last
  end

  def optimized_player_list
    Game.last ? all_players.to_a.push(Player.last_loser) : all_players
  end
end
