class Tournament < ActiveRecord::Base
  has_many :matchups

  def match_points_for(player)
    matchups.where(winner: player).count
  end

  def players
    Player.where id: matchups.pluck(:primary_id, :secondary_id).flatten.compact
  end

  def add_player(player)
    build_matchups_for player
  end

  private

  def build_matchups_for(player)
    players.each do |current_player|
      matchups << Matchup.create(primary_id: player.id, secondary_id: current_player.id)
    end
  end
end
