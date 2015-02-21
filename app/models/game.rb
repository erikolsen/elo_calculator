class Game < ActiveRecord::Base
  belongs_to :winner, class_name: 'Player'
  belongs_to :loser, class_name: 'Player'

  validates_presence_of :winner_id, :loser_id, :winner_rating, :loser_rating

  def can_undo?
    self == Game.last
  end

  def self.for_player(player_id)
    where("winner_id = #{player_id} or loser_id = #{player_id}")
  end
end
