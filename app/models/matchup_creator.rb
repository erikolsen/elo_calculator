class MatchupCreator
  include ActiveModel::Model

  attr_reader :game_results, :matchup, :primary_wins, :secondary_wins

  def initialize(params)
    @game_results = params[:game_results]
    @matchup = Matchup.find params[:matchup]
    @primary_wins = 0
    @secondary_wins = 0
  end

  def save
    return false unless valid_number_of_games

    game_results.values.each do |winner_id|
      create_game(winner_id)
      matchup.update winner: winner_id
    end
  end

  def create_game(winner_id)
    loser_id = opponent_of(winner_id)
    creator = GameCreator.new(winner_id, loser_id)
    creator.save
  end

  def winner_id
    return false if primary_wins == secondary_wins
    primary_wins > secondary_wins ? primary_id : secondary_id
  end

  def opponent_of(challenger_id)
    { primary_id => secondary_id, secondary_id => primary_id }[challenger_id.to_i]
  end

  private

  def primary_id
    matchup.primary
  end

  def secondary_id
    matchup.secondary
  end

  def tally_win(winner_id)
    (winner_id == primary_id) ? (@primary_wins+=1) : (@secondary_wins+=1)
  end

  def valid_number_of_games
    game_results.values.each{ |winner_id| tally_win(winner_id) }
    return false if primary_wins == secondary_wins
    return false unless primary_wins == 3 || secondary_wins == 3
    game_results.count <= 5 && game_results.count >= 3
  end
end
