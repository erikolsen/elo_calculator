module GamesHelper
  def all_players
    Player.by_name
  end

  def all_players_last_winner_default
    Game.last ? all_players.unshift(Game.last.winner).push(Game.last.loser) : all_players
  end
end
