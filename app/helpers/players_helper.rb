module PlayersHelper

  def top_ten_players
    Player.all.sort_by(&:rating).reverse.first(10)
  end

  def last_game
    Game.last
  end

  def winner_id
    last_game.winner_id || 1
  end

  def loser_id
    last_game.loser_id || 1
  end

  def all_players_exclude(players)
    Player.by_name - players
  end

end
