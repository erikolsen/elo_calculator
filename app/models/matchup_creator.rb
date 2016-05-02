class MatchupCreator
  include ActiveModel::Model

  attr_reader :primary_id, :secondary_id, :matchups, :primary_wins, :secondary_wins, :tournament_id

  def initialize(params)
    @primary_id = params['primary_id']
    @secondary_id = params['secondary_id']
    @matchups = params['tournament_matchups']
    @tournament_id = params['tournament_id']
    @primary_wins = 0
    @secondary_wins = 0
  end

  def save
    return false unless valid_number_of_games

    begin
      ActiveRecord::Base.transaction do
        matchups.values.each do |winner_id|
          return false unless create_game(winner_id)
        end 
      end
      true
    rescue
      errors.add :base, 'Failed to save match'
      false
    end
    tournament.matchups << Matchup.create(primary: primary_id,
                                         secondary: secondary_id,
                                         winner: winner_id)
  end

  def create_game(winner_id)
    loser_id = opponent_of(winner_id)
    creator = GameCreator.new(winner_id, loser_id)
    return creator.save
  end

  def winner_id
    return false if primary_wins == secondary_wins
    primary_wins > secondary_wins ? primary_id : secondary_id
  end

  def opponent_of(challenger_id)
    { primary_id => secondary_id, secondary_id => primary_id }[challenger_id]
  end

  private

  def tally_win(winner_id)
    (winner_id == primary_id) ? (@primary_wins+=1) : (@secondary_wins+=1)
  end

  def valid_number_of_games
    matchups.values.each{ |winner_id| tally_win(winner_id) }
    return false if primary_wins == secondary_wins
    matchups.count <= 5
  end
  
  def tournament
    @tournament ||= Tournament.find tournament_id
  end
end
