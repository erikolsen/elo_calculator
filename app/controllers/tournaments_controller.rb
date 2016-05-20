class TournamentsController < ApplicationController
  def index
    @tournaments = Tournament.all
  end

  def new
    @tournament = Tournament.new
  end

  def update
    @tournament = Tournament.find(params[:id])
    if tournament_params[:players].present?
      new_player = Player.find tournament_params[:players]
      @tournament.add_player new_player
      redirect_to @tournament
    else
      flash.now[:alert] = 'Failed to add player'
      flash.keep
      redirect_to @tournament
    end
  end

  def create
    creator = TournamentCreator.new(tournament_params[:name], tournament_params[:players])
    if creator.save
      @tournament = creator.tournament
      redirect_to @tournament, notice: 'Tournament created'
    else
      @tournament = Tournament.new
      flash.now[:alert] = creator.errors.full_messages.join('. ')
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
