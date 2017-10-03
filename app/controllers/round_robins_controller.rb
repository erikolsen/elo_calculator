class RoundRobinsController < ApplicationController
  def show
    @tournament = RoundRobin.find(params[:id])
    @player = Player.find(params[:player]) if params[:player]
    redirect_to tournament_entries_path(@tournament) unless @tournament.started?
  end
end
