class TournamentsController < ApplicationController
  def index
    @tournaments = Tournament.all
  end

  def new
    @tournament = Tournament.new
  end

  def update
    new_player = Player.find tournament_params[:players]
    @tournament = Tournament.find(params[:id])
    @tournament.add_player new_player
    redirect_to @tournament
  end

  def create
    creator = TournamentCreator.new(tournament_params[:name], tournament_params[:players])
    if creator.save
      @tournament = creator.tournament
      redirect_to @tournament, notice: 'Tournament created'
    else
      flash.now[:alert] = 'Tournament failed to save'
      render :new
    end
  end

  def show
    @tournament = Tournament.find(params[:id])
    @players = @tournament.players.sort_by(&:name)
    @potential_players = Player.by_name - @players
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, { players: [] }, :players)
  end
end
