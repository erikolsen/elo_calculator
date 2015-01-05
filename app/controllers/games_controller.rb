class GamesController < ApplicationController
  def new
    @players = Player.all.sort_by(&:name)
  end

  def create
    winner = Player.find(game_params[:winner])
    loser = Player.find(game_params[:loser])
    update_ratings(winner, loser)

    @game = Game.new(winner_name: winner.name,
                     winner_rating: winner.rating,
                     loser_name: loser.name,
                     loser_rating: loser.rating)
    @game.save 
    redirect_to :root
  end
  
  private
    def update_ratings(winner, loser)
      new_rating = RatingUpdater.new(winner, loser)
      winner.rating += new_rating.change_in_rating
      loser.rating -= new_rating.change_in_rating+1
      winner.save
      loser.save
    end

    def game_params
      params.require(:game).permit(:winner, :loser)
    end
end
