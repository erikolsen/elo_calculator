class TournamentCreator
  include ActiveModel::Model

  attr_accessor :players, :name, :tournament, :end_date, :tournament_type

  validate :no_duplicate_players, :must_have_two_players, :has_future_date, :has_tournament_type
  TOURNAMENT_TYPES = {'round_robin' => RoundRobin,
                      'single_elimination' => SingleElimination }

  def initialize(params)
    @name = params[:name]
    @players = params[:players]
    @end_date = params[:end_date].to_date
    @tournament_type = params[:tournament_type]
  end

  def save
    return false unless valid?
    ActiveRecord::Base.transaction do
      @tournament = Tournament.create(name: name, end_date: end_date, tournament_type: tournament_type)
      @tournament.players << Player.find(players)
      TOURNAMENT_TYPES[@tournament_type].build_matchups_for @tournament
      true
    end
  end

  private

  def has_tournament_type
    errors.add :base, 'Please select valid type' unless Tournament::TYPES.include? @tournament_type
  end

  def must_have_two_players
    errors.add :base, 'Must have at least two players' if players.count < 2
  end

  def has_future_date
    errors.add :base, 'End date must be in the future' if end_date < Date.current
  end

  def no_duplicate_players
    errors.add :base, 'Cannot have duplicate players' if players.count != players.uniq.count
  end
end
