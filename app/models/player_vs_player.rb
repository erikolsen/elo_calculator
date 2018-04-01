class PlayerVsPlayer
  attr_reader :primary, :secondary, :games

  def initialize(primary, secondary)
    @primary = primary
    @secondary = secondary
  end

  def games_won
    periods_played.reverse.map do |period|
      monthly = games.where(created_at: period.beginning_of_month .. period.end_of_month)
      won = monthly.where('winner_id = ?', primary.id).count
      lost = monthly.count - won
      [{ x: period.strftime('%m/%d/%y'), y: lost }, {x: period.strftime('%m/%d/%y'), y: won}]
    end
  end

  def winner_percent
    ((games.where('winner_id = ?', primary.id).count.to_f / games.count.to_f).round(2) * 100).floor.to_s + '%'
  end

  def loser_percent
    ((games.where('winner_id = ?', secondary.id).count.to_f / games.count.to_f).round(2) * 100).floor.to_s + '%'
  end

  def games
    @games ||= Game.for_players(primary, secondary).most_recent
  end

  private
  def percent_for(games)
    ((games.where('winner_id = ?', primary.id).count.to_f / games.count.to_f).round(2)).floor #.to_s + '%'
  end

  def periods_played
    #games.pluck(:created_at).map{|t| t.to_date }.uniq
    games.pluck(:created_at).map{|t| t.beginning_of_month }.uniq
  end

  def games_won_per(month)
    monthly = games.where(created_at: month.beginning_of_month .. month.end_of_month)
    return ((monthly.where('winner_id = ?', primary.id).count.to_f / monthly.count.to_f).round(2) * 100).floor #.to_s + '%'
    #monthly.inject(0) do |memo, game|
      #change = game.winner_id == primary.id ? 1 : -1
      #memo + change
    #end
  end
end
