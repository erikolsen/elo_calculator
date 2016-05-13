class Tournament < ActiveRecord::Base
  has_many :entries
  has_many :players, through: :entries
  has_many :matchups

  def match_points_for(player)
    matchups.where(winner: player).count
  end

  def add_player(player)
    players << player
    build_matchups_for player
   end

  private

  def build_matchups_for(player)
    players.each do |current_player|
      matchups << Matchup.create(primary: player, secondary: current_player)
    end
  end
end
