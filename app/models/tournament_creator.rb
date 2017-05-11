class TournamentCreator
  include ActiveModel::Model

  attr_accessor :players, :name, :tournament, :end_date

  validate :no_duplicate_players, :must_have_two_players, :has_future_date

  def initialize(params)
    @name = params[:name]
    @players = params[:players]
    @end_date = params[:end_date].to_date
  end

  def save
    return false unless valid?
    @tournament = Tournament.create(name: name, end_date: end_date)
    @tournament.players << Player.find(players)
    create_matchups
    true
  end

  private

  def create_matchups
    players.combination(2).each do |combo|
      tournament.matchups << Matchup.create(primary_id: combo.first,
                                            secondary_id: combo.second)
    end
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
