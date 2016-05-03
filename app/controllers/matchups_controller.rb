class MatchupsController < ApplicationController
  def new
    @players = players
    @tournament = Tournament.find(params[:tournament_id])
  end

  def create
    creator = MatchupCreator.new params
    if creator.save
      redirect_to Tournament.find creator.tournament_id
    else
      redirect_to :new
    end
  end

  private

  def players
    params[:players].map{ |id| Player.find(id) }
  end
end
