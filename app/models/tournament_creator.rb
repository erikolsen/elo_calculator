class TournamentCreator
  include ActiveModel::Model

  attr_accessor :players, :name, :tournament

  validate :no_duplicate_players

  def initialize(name, players)
    @name = name
    @players = players.map{|id| Player.find(id) }
  end

  def save
    return false unless valid?

    @tournament = Tournament.create(name: name)
    @tournament.players = players
  end

  private

  def no_duplicate_players
    errors.add :base, 'Cannot have duplicate players' if players.count != players.uniq.count
  end
end
