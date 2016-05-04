class Tournament < ActiveRecord::Base
  has_many :entries
  has_many :players, through: :entries
  has_many :matchups

  def match_points_for(player)
    matchups.where(winner: player).count
  end
end
