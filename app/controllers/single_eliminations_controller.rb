class SingleEliminationsController < ApplicationController
  def show
    @tournament = SingleElimination.find(params[:id])
    redirect_to tournament_entries_path(@tournament) unless @tournament.started?
  end
end
