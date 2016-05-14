class MatchupsController < ApplicationController
  def edit
    @matchup = Matchup.find(params[:id])
    @tournament = Tournament.find(params[:tournament_id])
    @players = @matchup.players
  end

  def update
    @tournament = Tournament.find params[:tournament_id]
    if @tournament.add_game_results(params[:id], params[:games])
      redirect_to @tournament
    else
      flash.now[:alert] = 'Matches failed to save'
      render :new
    end
  end
end
