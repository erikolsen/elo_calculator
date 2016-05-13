class Tournament < ActiveRecord::Base
  has_many :entries
  has_many :players, through: :entries
  has_many :matchups

  def match_points_for(player)
    matchups.where(winner: player).count
  end

  def add_player(player)
    players << player
    matchups << players.map { |current_player| Matchup.create primary: player, secondary: current_player }
   end
end
