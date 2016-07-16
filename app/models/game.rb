class Game < ActiveRecord::Base
  belongs_to :winner, class_name: 'Player'
  belongs_to :loser, class_name: 'Player'
  belongs_to :matchup

  validates_presence_of :winner_id, :loser_id, :winner_rating, :loser_rating

  scope :most_recent, -> { order(id: :desc) }
  scope :played_on, ->(date) { where(created_at: (date.beginning_of_day..date.end_of_day)).reverse_order }

  def can_undo?
    self == Game.last
  end

  def self.for_player(player_id)
    where("winner_id = #{player_id} or loser_id = #{player_id}")
  end

  def next_game_for(player)
    Game.for_player(player.id).where('created_at > ?', created_at).first
  end

  def rating_for_player(player)
    winner_id == player.id ? winner_rating : loser_rating
  end

  def opponent_of(player)
    winner_id == player.id ? loser : winner
  end
end
