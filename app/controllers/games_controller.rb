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
    update_ratings(winner, loser)

    @game.save 
    redirect_to :root
  end


  private
    def update_ratings(winner, loser)
      winner.rating += 5
      loser.rating -= 5
      winner.save && loser.save
    end

    def game_params
      params.require(:game).permit(:winner_name, :loser_name)
    end
end
