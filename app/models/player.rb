class Player < ActiveRecord::Base
  has_many :won_games, foreign_key: 'winner_id', class_name: 'Game'
  has_many :lost_games, foreign_key: 'loser_id', class_name: 'Game'

  def rating
    self[:rating].to_i
  end

  def rating=(value)
    self[:rating] = value.to_s
  end

  def games_won
    won_games.count
  end

  def games_lost
    lost_games.count
  end

  def games_played
    games_won + games_lost
  end
end
