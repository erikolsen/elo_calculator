module PlayersHelper
  
  def last_game
    Game.last
  end

  def winner_id
    last_game.winner_id || 1
  end

  def loser_id
    last_game.loser_id || 1
  end

  def five_minute_color
    '#1E6823'
  end
  
  def ten_minute_color
    '#44A340'
  end
  
  def fifteen_minute_color
    '#8CC665'
  end
  
  def twenty_minute_color
    '#D6E685'
  end
  
  def thirty_minute_color
    '#EEEEEE'
  end

  def color_based_on_last_game
    return five_minute_color if last_game.created_at < 5.minutes.ago 
    return ten_minute_color if last_game.created_at < 10.minutes.ago 
    return fifteen_minute_color if last_game.created_at < 15.minutes.ago 
    return twenty_minute_color if last_game.created_at < 20.minutes.ago 
    return thirty_minute_color if last_game.created_at < 30.minutes.ago 
    'black' # by default
  end

end
