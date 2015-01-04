class GamesController < ApplicationController
  def new
  end

  def create
    winner = Player.find_by_name(game_params[:winner_name])
    loser = Player.find_by_name(game_params[:loser_name])

    @game = Game.new(winner_name: winner.name,
                     winner_rating: winner.rating,
                     loser_name: loser.name,
                     loser_rating: loser.rating)
    new_rating = RatingUpdater.new(winner, loser)
    winner.rating += new_rating.change_in_rating
    loser.rating -= new_rating.change_in_rating+1
    winner.save
    loser.save

    @game.save 
    redirect_to :root
  end

  class RatingUpdater
    attr_reader :winner, :loser
    K_FACTOR = 50.00

    def initialize(winner, loser)
      @winner = winner
      @loser = loser
    end

    def difference_in_ratings
      (winner.rating - loser.rating)
    end

    def the_pow
      (difference_in_ratings.to_f / 400.00).round(2)
    end

    def the_exponenet
      (10.00**the_pow.to_f)
    end

    def the_denominator
      (the_exponenet.to_f + 1.00)
    end

    def loser_percent
      (1.00 / the_denominator.to_f)
    end

    def winner_percent
      1.00 - loser_percent.to_f
    end

    def change_in_rating
      (K_FACTOR * (1.00 - winner_percent.to_f)).ceil
    end

  end


  private

    def game_params
      params.require(:game).permit(:winner_name, :loser_name)
    end
end
