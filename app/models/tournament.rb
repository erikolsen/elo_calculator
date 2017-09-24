# == Schema Information
#
# Table name: tournaments
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#  end_date   :datetime
#  type       :string
#
# Indexes
#
#  index_tournaments_on_type  (type)
#

class Tournament < ApplicationRecord
  TYPES = %w( RoundRobin SingleElimination )
  has_many :entries
  has_many :players, through: :entries
  has_many :matchups

  scope :active, -> { where('end_date >= ?', Date.current).order(end_date: :desc) }
  scope :expired, -> { where('end_date < ?', Date.current).order(end_date: :desc) }

  validates :name, presence: true
  validates :end_date, presence: true
  validates :type, presence: true

  def matchups_for(player)
    matchups.where("primary_id = #{player.id} or secondary_id = #{player.id}")
  end

  def match_points_for(player)
    matchups.where(winner: player).count
  end

  def complete?
    matchups.where(winner_id: nil).empty?
  end

  def expired?
    end_date < Date.current if end_date
  end
end
