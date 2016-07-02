class Player < ActiveRecord::Base
  has_many :won_games, foreign_key: 'winner_id', class_name: 'Game'
  has_many :lost_games, foreign_key: 'loser_id', class_name: 'Game'
  has_many :entries
  has_many :tournaments, through: :entries

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

  def highest_rating_achieved
    lost_games.pluck(:loser_rating).push(rating).max
  end

  def opponents
    games.pluck(:winner_id, :loser_id).flatten - [id]
  end

  def top_five_opponents
    opponents_by_games_played.take(5).map{ |id| Player.find id }
  end

  def opponents_by_games_played
    opponents.inject(Hash.new(0)){|h, p| h[p] +=1;h }.sort_by{|_, v| v}.reverse.to_h.keys
  end

  def win_percentage
    return 0 if games_won_count.zero?
    (games_won_count.to_f / games_played_count.to_f).round(2) * 100.0
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

  def tournaments_played_count
    tournaments.count
  end

  def add_rating!(change_in_rating)
    update_attributes!(rating: rating + change_in_rating)
  end

  def subtract_rating!(change_in_rating)
    update_attributes!(rating: rating - change_in_rating)
  end
end
