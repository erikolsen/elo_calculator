class Game < ActiveRecord::Base
  belongs_to :winner, class_name: 'Player'
  belongs_to :loser, class_name: 'Player'
  belongs_to :matchup

  validates_presence_of :winner_id, :loser_id, :winner_rating, :loser_rating

  scope :most_recent, -> { order(id: :desc) }

  def can_undo?
    self == Game.last
  end

  def self.for_player(player_id)
    where("winner_id = #{player_id} or loser_id = #{player_id}")
  end

  def opponent_of(player)
    winner_id == player.id ? loser : winner
  end
end
