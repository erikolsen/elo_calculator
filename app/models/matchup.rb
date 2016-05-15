class Matchup < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :winner, class_name: 'Player'
  belongs_to :primary, class_name: 'Player'
  belongs_to :secondary, class_name: 'Player'
  has_many :games

  def self.for_players(*players)
    where(primary_id: players, secondary_id: players).first
  end

  def add_game_results(game_results)
    MatchupCreator.new(matchup: self, game_results: game_results).save
  end

  def players
    [primary, secondary]
  end
end
