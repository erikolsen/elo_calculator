module GamesHelper
  def all_players
    Player.by_name
  end

  def all_players_last_winner_default
    #optimized_player_list = all_players.unshift(Game.last.winner).push(Game.last.loser)
    last_winner = Player.where(id: Game.last.winner.id)
    last_loser = Player.where(id: Game.last.loser.id)
    optimized_player_list = last_winner + all_players + last_loser
    Game.last ? optimized_player_list : all_players
  end
end
