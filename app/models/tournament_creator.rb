class TournamentCreator
  include ActiveModel::Model

  attr_accessor :players, :name, :tournament, :player_ids

  validate :no_duplicate_players, :must_have_two_players

  def initialize(name, players)
    @name = name
    @player_ids = players
    @players = Player.where(id: players)
  end

  def save
    return false unless valid?

    @tournament = Tournament.create(name: name)
    @tournament.players = players
    create_matchups
  end

  private

  def create_matchups
    player_ids.combination(2).each do |tuple|
      tournament.matchups << Matchup.create(primary: tuple.first, secondary: tuple.second)
    end
  end

  def must_have_two_players
    errors.add :base, 'Must have at least two players' if players.count < 2
  end

  def no_duplicate_players
    errors.add :base, 'Cannot have duplicate players' if players.count != players.uniq.count
  end
end
