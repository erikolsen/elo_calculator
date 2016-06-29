class Tournament < ActiveRecord::Base
  has_many :entries
  has_many :players, through: :entries
  has_many :matchups

  def players_by_points
    players.sort do |x,y|
      match_points_for(y) <=> match_points_for(x)
    end
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
    build_matchups_for player
    players << player
  end

  def expired?
    end_date < Date.today if end_date
  end

  private

  def build_matchups_for(player)
    players.each do |current_player|
      matchups << Matchup.create(primary_id: player.id, secondary_id: current_player.id)
    end
  end
end
