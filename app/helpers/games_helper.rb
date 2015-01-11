module GamesHelper
  def all_players
    Player.by_name
  end
end
