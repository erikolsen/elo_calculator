class MatchupsController < ApplicationController
  def new
    @players = players
    @tournament = Tournament.find(params[:tournament_id])
  end

  def create
    creator = MatchupCreator.new params
    @tournament = Tournament.find creator.tournament_id
    @players = [params[:primary_id], params[:secondary_id]].map{|id| Player.find(id)}
    if creator.save
      redirect_to @tournament
    else
      flash.now[:alert] = 'Matches failed to save'
      render :new
    end
  end

  private

  def players
    params[:players].map{ |id| Player.find(id) }
  end
end
