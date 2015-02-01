class GameDestroyer
  include ActiveModel::Model

  attr_reader :bad_game

  def initialize(bad_game = nil)
    @bad_game = bad_game
  end

  def undo_game!
    return false unless bad_game_is_last_game
    begin
      ActiveRecord::Base.transaction do
        reset_player_ratings
        bad_game.destroy
      end
      
      return true
    rescue ActiveRecord::RecordInvalid => record
      errors.add :base, 'Failed to delete game'
      return false
    end
  end

  private

  def bad_game_is_last_game
    bad_game == Game.last 
  end

  def reset_player_ratings
    winner = bad_game.winner
    loser = bad_game.loser
    winner.rating = bad_game.winner_rating
    loser.rating = bad_game.loser_rating
    winner.save
    loser.save
  end

end
