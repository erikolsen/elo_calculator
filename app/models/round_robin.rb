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

  def match_points_for(player)
    matchups.where(winner: player).count
  end

  def matchups_for(player)
    matchups.where("primary_id = #{player.id} or secondary_id = #{player.id}")
  end

  def add_player(player)
    players.each do |current_player|
      matchups << Matchup.create(primary_id: player.id, secondary_id: current_player.id)
    end
    players << player
  end
end
