class MatchupCreator
  include ActiveModel::Model

  attr_reader :game_results, :matchup, :primary_wins, :secondary_wins

  def initialize(params)
    @game_results = params[:game_results].values
    @matchup = Matchup.find params[:matchup_id]
    calculate_wins
  end

  def save
    return false unless valid_number_of_games

    game_results.each do |winner|
      create_game(winner)
    end
    matchup.update winner_id: winner_id
  end

  def create_game(winner)
    loser = opponent_of(winner)
    creator = GameCreator.new(winner, loser)
    creator.save
    matchup.games << creator.game
  end

  def winner_id
    return false unless valid_number_of_games
    primary_wins > secondary_wins ? primary_id : secondary_id
  end

  def opponent_of(challenger_id)
    { primary_id => secondary_id, secondary_id => primary_id }[challenger_id.to_i]
  end

  private

  def primary_id
    matchup.primary_id
  end

  def secondary_id
    matchup.secondary_id
  end

  def calculate_wins
    @primary_wins = 0
    @secondary_wins = 0
    game_results.each{ |winner_id| tally_win(winner_id) }
  end

  def tally_win(winner_id)
    (winner_id.to_i == primary_id) ? (@primary_wins+=1) : (@secondary_wins+=1)
  end

  def valid_number_of_games
    return false if primary_wins == secondary_wins
    return false unless primary_wins == 3 || secondary_wins == 3
    game_results.count <= 5 && game_results.count >= 3
  end
end
