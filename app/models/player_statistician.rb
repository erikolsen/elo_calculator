class PlayerStatistician
  attr_reader :player

  def initialize(player)
    @player = player
  end

  def win_percentage
    return 0 if games_won_count.zero?
    (games_won_count.to_f / games.count.to_f).round(2) * 100.0
  end

  def daily_rating_change
    rating - start_rating_on(Date.current)
  end

  def highest_rating_achieved
    lost_games.pluck(:loser_rating).push(rating).max
  end

  def rating
    player.rating
  end

  def average_rating
    return 1000 if games.empty?
    games.inject(rating){ |sum, game| sum += game.rating_for(player) } / (games.count + 1)
  end

  def ratings_over_time
    days_played.reverse.map do |day|
      { x: day, y: start_rating_on(day)}
    end
  end

  def days_played
    games.pluck(:created_at).map{|t| t.to_date }.uniq
  end

  def top_ten_opponents
    opponents_by_games_played.take(10).map{ |id| Player.find id }
  end

  def rating_change_on(day)
    next_rating_from(day) - start_rating_on(day)
  end

  private

  def games
    @games ||= player.games
  end

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
    game.rating_for player
  end

  def next_game_from(day)
    played_games = games.played_on(day)
    return nil if played_games.empty?
    played_games.last.next_game_for player
  end

  def next_rating_from(day)
    game = next_game_from(day)
    return rating if game.nil?
    game.rating_for player
  end

  def games_won_count
    @games_won_count ||= player.won_games.count
  end

  def lost_games
    player.lost_games
  end
end
