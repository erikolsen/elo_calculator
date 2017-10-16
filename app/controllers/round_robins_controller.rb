class RoundRobinsController < ApplicationController
  def show
    @tournament = RoundRobin.find(params[:id])
    redirect_to tournament_entries_path(@tournament) unless @tournament.started?
  end
end
