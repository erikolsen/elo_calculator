class Matchup < ApplicationRecord
  belongs_to :tournament
  belongs_to :winner, class_name: 'Player'
  belongs_to :primary, class_name: 'Player'
  belongs_to :secondary, class_name: 'Player'
  has_many :games

  def self.for_players(*players)
    where(primary_id: players, secondary_id: players).first
  end

  def can_undo?
    games.include? Game.last
  end

  def add_game_results(game_results)
    return false if game_results.nil? || game_results.count < 3
    MatchupCreator.new(matchup_id: id, game_results: game_results).save
  end

  def opponent_of(challenger)
    challenger == primary ? secondary : primary
  end

  def players
    [primary, secondary]
  end
end
