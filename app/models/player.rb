# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  rating     :integer          default(0), not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_players_on_name    (name)
#  index_players_on_rating  (rating)
#

class Player < ApplicationRecord
  has_many :won_games, foreign_key: 'winner_id', class_name: 'Game'
  has_many :lost_games, foreign_key: 'loser_id', class_name: 'Game'
  has_many :entries
  has_many :tournaments, through: :entries

  has_many :memberships
  has_many :clubs, through: :memberships

  validates_presence_of :name, :rating
  validates_uniqueness_of :name

  scope :by_name, -> { order(:name) }

  def self.last_winner
    Game.last.winner
  end

  def self.last_loser
    Game.last.loser
  end

  def games
    Game.for_player(self.id).most_recent
  end

  def add_rating!(change_in_rating)
    update_attributes!(rating: rating + change_in_rating)
  end

  def subtract_rating!(change_in_rating)
    update_attributes!(rating: rating - change_in_rating)
  end
end
