class RoundRobinsController < ApplicationController
  def show
    @tournament = RoundRobin.find(params[:id])
    @player = Player.find(params[:player]) if params[:player]
  end

  private

  def round_robin_params
    params.require(:round_robin).permit({ players: [] }, :players)
  end
end
