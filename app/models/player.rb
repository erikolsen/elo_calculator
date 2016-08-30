class Player < ActiveRecord::Base
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

  def days_played
    games.pluck(:created_at).map{|t| t.to_date }.uniq
  end

  def average_rating_change
    ratings = days_played.map { |day| rating_change_on day }
    ratings.present? ? ratings.sum / ratings.count : 0
  end

  def rating_change_on(day)
    next_rating_from(day) - start_rating_on(day)
  end

  def chronological_games
    Game.for_player(self.id).chronologically
  end

  def daily_rating_change
    rating_change_on Date.today
  end

  def next_rating_from(day)
    game = next_game_from(day)
    return rating if game.nil?
    game.rating_for_player self
  end

  def next_game_from(day)
    played_games = games.played_on(day)
    return nil if played_games.empty?
    played_games.last.next_game_for self
  end

  def start_rating_on(day)
    game = games.played_on(day).first || next_game_from(day)
    return rating unless game
    game.rating_for_player self
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

  def ratings_over_time
    days_played.reverse.map do |day|
      { x: day, y: start_rating_on(day)}
    end
  end
end
