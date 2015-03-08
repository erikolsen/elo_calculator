class PlayersController < ApplicationController
  def index
    @players = Player.by_rating
  end

  def show
    @player = Player.find(params[:id])
  end

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)
    @player.rating = 1000

    if @player.save
      redirect_to root_path, notice: 'Player created'
    else
      flash.now[:alert] = 'Player failed to save'
      render :new
    end
  end

  private

  def player_params
    params.require(:player).permit(:name, :rating)
  end
end
