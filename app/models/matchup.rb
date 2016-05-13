class Matchup < ActiveRecord::Base
  belongs_to :tournament

  def self.for_players(*players)
    where(primary: players, secondary: players).first
  end
end
