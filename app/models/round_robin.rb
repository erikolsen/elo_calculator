# == Schema Information
#
# Table name: tournaments
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#  end_date   :datetime
#  type       :string
#  start_date :datetime
#
# Indexes
#
#  index_tournaments_on_type  (type)
#

class RoundRobin < Tournament
  def build_matchups!
    players.map(&:id).combination(2).each do |combo|
      matchups << Matchup.create(primary_id: combo.first,
                                 secondary_id: combo.second)
    end
  end

  def players_by_points
    players.sort { |x,y|  match_points_for(y) <=> match_points_for(x) }
  end

  def rank_for(player)
    (players_by_points.find_index(player) + 1).ordinalize
  end

  def add_player(player)
    players.each do |current_player|
      matchups << Matchup.create(primary_id: player.id, secondary_id: current_player.id)
    end
    players << player
  end
end
