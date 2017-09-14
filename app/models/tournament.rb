# == Schema Information
#
# Table name: tournaments
#
#  id              :integer          not null, primary key
#  name            :string
#  created_at      :datetime
#  updated_at      :datetime
#  end_date        :datetime
#  tournament_type :string
#

class Tournament < ApplicationRecord
  TYPES = %w( round_robin single_elimination )
  has_many :entries
  has_many :players, through: :entries
  has_many :matchups
  has_many :bracket_matchups, -> { order 'tournament_sequence asc' }

  scope :active, -> { where('end_date >= ?', Date.current).order(end_date: :desc) }
  scope :expired, -> { where('end_date < ?', Date.current).order(end_date: :desc) }

  validates :name, presence: true
  validates :end_date, presence: true
  validates :tournament_type, presence: true

  def single_bracket_by_round
    SingleEliminationPresenter.present bracket_matchups.where(bracket_type: 'winners')
  end

  def losers
    bracket_matchups.where(bracket_type: 'losers').first
  end

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
