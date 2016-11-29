class PlayerStatistician
  attr_reader :games, :player

  def initialize(player)
    @player = player
  end

  def win_percentage
    return 0 if games_won.count.zero?
    (games_won.count.to_f / games.count.to_f).round(2) * 100.0
  end

  def daily_rating_change
    rating_change_on Date.current
  end

  def highest_rating_achieved
    lost_games.pluck(:loser_rating).push(rating).max
  end

  def rating
    player.rating
  end

  def average_rating
    return 0 if days_played.empty?
    days_played.map{|day| next_rating_from day }.sum / days_played.count
  end

  def ratings_over_time
    days_played.reverse.map do |day|
      { x: day, y: start_rating_on(day)}
    end
  end

  def days_played
    games.pluck(:created_at).map{|t| t.to_date }.uniq
  end

  def top_five_opponents
    opponents_by_games_played.take(5).map{ |id| Player.find id }
  end

  def rating_change_on(day)
    next_rating_from(day) - start_rating_on(day)
  end

  def games
    @games ||= player.games
  end

  private

  def opponents
    games.pluck(:winner_id, :loser_id).flatten - [player.id]
  end

  def opponents_by_games_played
    opponents.inject(Hash.new(0)){|h, p| h[p] +=1;h }.sort_by{|_, v| v}.reverse.to_h.keys
  end

  def average_rating_change
    ratings = days_played.map { |day| rating_change_on day }
    ratings.present? ? ratings.sum / ratings.count : 0
  end

  def start_rating_on(day)
    game = games.played_on(day).first || next_game_from(day)
    return rating unless game
    game.rating_for_player player
  end

  def next_game_from(day)
    played_games = games.played_on(day)
    return nil if played_games.empty?
    played_games.last.next_game_for player
  end

  def next_rating_from(day)
    game = next_game_from(day)
    return rating if game.nil?
    game.rating_for_player player
  end

  def games_won
    games.where(winner_id: @player.id)
  end

  def lost_games
    games.where(loser_id: @player.id)
  end
end
