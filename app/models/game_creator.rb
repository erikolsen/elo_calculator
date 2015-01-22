class GameCreator
  include ActiveModel::Model

  attr_accessor :winner_id, :loser_id

  validate :not_same_player

  def initialize(winner_id = nil, loser_id = nil)
    @winner_id = winner_id
    @loser_id = loser_id
  end

  def save
    return false unless valid?

    change_in_rating = RatingUpdater.new(winner.rating, loser.rating).change_in_rating

    begin
      ActiveRecord::Base.transaction do
        @game = Game.create!(winner_id: winner.id, loser_id: loser.id, winner_rating: winner.rating, loser_rating: loser.rating)
        winner.add_rating!(change_in_rating)
        loser.subtract_rating!(change_in_rating)
      end

      @game
    rescue ActiveRecord::RecordInvalid => record
      errors.add :base, 'Failed to save game'
      false
    end
  end

  private

  def not_same_player
    errors.add :base, 'Winner and loser cannot be same player' if loser_id == winner_id
  end

  def winner
    Player.find(@winner_id)
  end

  def loser
    Player.find(@loser_id)
  end
end
