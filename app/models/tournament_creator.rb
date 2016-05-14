class TournamentCreator
  include ActiveModel::Model

  attr_accessor :players, :name, :tournament

  validate :no_duplicate_players, :must_have_two_players

  def initialize(name, players)
    @name = name
    @players = players
  end

  def save
    return false unless valid?
    @tournament = Tournament.create(name: name)
    create_matchups
  end

  private

  def create_matchups
    players.combination(2).each do |combo|
      tournament.matchups << Matchup.create(primary: combo.first,
                                            secondary: combo.second)
    end
  end

  def must_have_two_players
    errors.add :base, 'Must have at least two players' if players.count < 2
  end

  def no_duplicate_players
    errors.add :base, 'Cannot have duplicate players' if players.count != players.uniq.count
  end
end
