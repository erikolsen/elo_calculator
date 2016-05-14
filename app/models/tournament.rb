class Tournament < ActiveRecord::Base
  has_many :matchups

  def match_points_for(player)
    matchups.where(winner: player).count
  end

  def players
    Player.where id: matchups.pluck(:primary, :secondary).flatten.compact
  end

  def add_player(player)
    build_matchups_for player
  end

  def add_game_results(matchup, game_results)
     MatchupCreator.new(matchup: matchup, game_results: game_results).save
  end

  private

  def build_matchups_for(player)
    players.each do |current_player|
      matchups << Matchup.create(primary: player.id, secondary: current_player.id)
    end
  end
end
