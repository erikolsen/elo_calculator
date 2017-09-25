class SingleEliminationsController < ApplicationController
  def show
    @tournament = SingleElimination.find(params[:id])
    @player = Player.find(params[:player]) if params[:player]
  end
end
