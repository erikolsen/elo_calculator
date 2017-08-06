class Tournament < ApplicationRecord
  TYPES = %w( round_robin )
  has_many :entries
  has_many :players, through: :entries
  has_many :matchups

  scope :active, -> { where('end_date >= ?', Date.current).order(end_date: :desc) }
  scope :expired, -> { where('end_date < ?', Date.current).order(end_date: :desc) }

  validates :name, presence: true, uniqueness: true
  validates :end_date, presence: true
  validates :tournament_type, presence: true

  def players_by_points
    players.sort { |x,y|  match_points_for(y) <=> match_points_for(x) }
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

  def complete?
    matchups.where(winner_id: nil).empty?
  end

  def expired?
    end_date < Date.current if end_date
  end

  private

  def build_matchups_for(player)
    players.each do |current_player|
      matchups << Matchup.create(primary_id: player.id, secondary_id: current_player.id)
    end
  end
end
