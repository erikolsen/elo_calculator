class RoundRobinsController < ApplicationController
  def show
    @tournament = RoundRobin.find(params[:id])
    @player = Player.find(params[:player]) if params[:player]
  end

  def update
    @tournament = RoundRobin.find(params[:id])
    if round_robin_params[:players].present?
      new_player = Player.find round_robin_params[:players]
      @tournament.add_player new_player
      redirect_to @tournament
    else
      flash.now[:alert] = 'Failed to add player'
      flash.keep
      redirect_to @tournament
    end
  end
  private

  def round_robin_params
    params.require(:round_robin).permit({ players: [] }, :players)
  end
end
