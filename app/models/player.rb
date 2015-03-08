class Player < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :won_games, foreign_key: 'winner_id', class_name: 'Game'
  has_many :lost_games, foreign_key: 'loser_id', class_name: 'Game'

  validates_presence_of :name, :rating

  scope :by_name, -> { order(:name) }
  scope :by_rating, -> { order(rating: :desc) }

  def self.for_homepage
    played_in_last_week.by_rating
  end

  def self.played_in_last_week
    uniq.joins('join games on games.winner_id = players.id or games.loser_id = players.id').where('games.created_at >= ?', Time.now - 7.days)
  end

  def games
    Game.for_player(self.id).most_recent
  end

  def games_won_count
    won_games.count
  end

  def games_lost_count
    lost_games.count
  end

  def games_played_count
    games.count
  end

  def add_rating!(change_in_rating)
    update_attributes!(rating: rating + change_in_rating)
  end

  def subtract_rating!(change_in_rating)
    update_attributes!(rating: rating - change_in_rating)
  end
end
