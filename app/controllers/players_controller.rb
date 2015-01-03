class PlayersController < ApplicationController
  def index
    @players = Player.all
  end

  def show
    @player = Player.find(params[:id])
  end

  def new
  end

  def create
    @player = Player.new(player_params)

    @player.save
    redirect_to :root 
  end

  private
    def player_params
      params.require(:player).permit(:name, :rating)
    end
end
