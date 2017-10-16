class TournamentCreator
  include ActiveModel::Model

  attr_accessor :players, :name, :tournament, :end_date, :type
  validate :no_duplicate_players, :must_have_two_players, :has_future_date, :has_type

  def initialize(params)
    @name = params[:name]
    @players = params[:players]
    @end_date = params[:end_date].to_datetime
    @type = params[:type]
  end

  def save
    return false unless valid?
    ActiveRecord::Base.transaction do
      @tournament = Tournament.create(name: name, end_date: end_date, type: type)
      @tournament.players << Player.find(players)
      true
    end
  end

  private

  def has_type
    errors.add :base, 'Please select valid type' unless Tournament::TYPES.include? @type
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
