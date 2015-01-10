class Player < ActiveRecord::Base
  def rating
    self[:rating].to_i
  end

  def rating=(value)
    self[:rating] = value.to_s
  end

  def games_won
    Game.where(:winner_name => self.name).count
  end

  def games_lost
    Game.where(:loser_name => self.name).count
  end

  def games_played
    games_won + games_lost
  end
end
