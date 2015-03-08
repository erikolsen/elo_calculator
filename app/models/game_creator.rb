class GameCreator
  include ActiveModel::Model

  attr_accessor :winner_id, :loser_id, :game

  validate :not_same_player, :players_exist

  def initialize(winner_id = nil, loser_id = nil)
    @winner_id = winner_id
    @loser_id = loser_id
  end

  def save
    return false unless valid?

    change_in_rating = RatingUpdater.new(winner.rating, loser.rating).change_in_rating

    begin
      ActiveRecord::Base.transaction do
        create_game
        winner.add_rating!(change_in_rating)
        loser.subtract_rating!(change_in_rating)
      end

      true
    rescue ActiveRecord::RecordInvalid => record
      errors.add :base, 'Failed to save game'
      false
    end
  end

  private

  def create_game
    @game = Game.create!(
        winner_id: winner.id,
        loser_id: loser.id,
        winner_rating: winner.rating,
        loser_rating: loser.rating
        )
  end

  def players_exist
    errors.add :base, 'Loser does not exist' unless loser
    errors.add :base, 'Winner does not exist' unless winner
  end

  def not_same_player
    errors.add :base, 'Winner and loser cannot be same player' if loser_id == winner_id
  end

  def winner
    Player.where(id: @winner_id).first
  end

  def loser
    Player.where(id: @loser_id).first
  end
end
