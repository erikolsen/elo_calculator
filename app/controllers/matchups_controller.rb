class MatchupsController < ApplicationController
  def new
    @matchup = Matchup.new(primary_id: primary_id,
                           secondary_id: secondary_id,
                           series_max: 5)
  end

  def create
    @matchup = Matchup.create(primary_id: primary_id,
                              secondary_id: secondary_id,
                              series_max: series_max)
    if @matchup.add_game_results(games_params)
      redirect_to @matchup
    else
      flash.now[:alert] = 'Matches failed to create'
      render :edit
    end
  end

  def show
    @matchup = Matchup.find(params[:id])
  end

  def edit
    @matchup = Matchup.find(params[:id])
    if @matchup.winner
      redirect_to matchup_path(@matchup)
    end
  end

  def update
    @matchup = Matchup.find(params[:id])
    if @matchup.add_game_results(games_params)
      redirect_to @matchup
    else
      flash.now[:alert] = 'Matches failed to create'
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

  private

  def games_params
    params.require(:games).permit!.to_h
  end

  def series_max
    params[:series_max]
  end

  def primary_id
    params[:primary_id]
  end

  def secondary_id
    params[:secondary_id]
  end

  def different_players
    secondary_id != primary_id
  end
end
