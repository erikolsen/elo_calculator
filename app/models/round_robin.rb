module RoundRobin
  def self.build_matchups_for(tournament)
    tournament.players.map(&:id).combination(2).each do |combo|
      tournament.matchups << Matchup.create(primary_id: combo.first,
                                            secondary_id: combo.second)
    end
  end
end
