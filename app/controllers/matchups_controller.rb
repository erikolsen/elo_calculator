class MatchupsController < ApplicationController
  def show
    @matchup = Matchup.find(params[:id])
  end

  def edit
    @matchup = Matchup.find(params[:id])
  end

  def update
    @matchup = Matchup.find(params[:id])
    if @matchup.add_game_results(params[:games])
      redirect_to @matchup
    else
      flash.now[:alert] = 'Matches failed to save'
      render :edit
    end
  end

  def destroy
    @matchup = Matchup.find(params[:id])
    @matchup.update winner_id: nil
    @matchup.games.reverse.each do |game|
      GameDestroyer.new(game).undo_game!
    end
    redirect_to edit_matchup_path, notice: 'Match Destroyed'
  end
end
