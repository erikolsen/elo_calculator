class MatchesController < ApplicationController
  def new
    @players = players
    @tournament = Tournament.find(params[:tournament_id])
    @match = Match.new
  end

  def create

  end

  private

  def players
    params[:players].map{ |id| Player.find(id) }
  end

end
