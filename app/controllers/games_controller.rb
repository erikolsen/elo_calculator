class GamesController < ApplicationController
  def index
    @games = Game.all.reverse
  end

  def new
    @game = GameCreator.new
  end

  def create
    @game = GameCreator.new(game_params[:winner_id], game_params[:loser_id])

    if @game.save
      redirect_to @game, notice: 'Game created'
    else
      flash.now[:alert] = @game.errors.full_messages.join('. ')
      render :new
    end
  end

  def show
  end

  private

  def game_params
    params.require(:game).permit(:winner_id, :loser_id)
  end
end
