class TournamentCreator
  include ActiveModel::Model

  attr_accessor :players, :name, :tournament, :end_date, :type, :series_max
  validate :no_duplicate_players, :must_have_two_players, :has_future_date, :has_type, :has_valid_series_max

  def initialize(params)
    @name = params[:name]
    @players = params[:players]
    @end_date = params[:end_date].to_datetime
    @series_max = params[:series_max]
    @type = params[:type]
  end

  def save
    return false unless valid?
    ActiveRecord::Base.transaction do
      @tournament = Tournament.create(name: name,
                                      series_max: series_max,
                                      end_date: end_date,
                                      type: type)
      @tournament.players << Player.find(players)
      true
    end
  end

  private

  def has_valid_series_max
    errors.add :base, 'Please select valid series max' unless Tournament::SERIES_MAXES.include? @series_max.to_i
  end

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
