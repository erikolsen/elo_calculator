class TournamentsController < ApplicationController
  def index
    @active_tournaments = Tournament.active
    @expired_tournaments = Tournament.expired
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
    creator = TournamentCreator.new(tournament_params)
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
    @player = Player.find(params[:player]) if params[:player]
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, :end_date, { players: [] }, :players)
  end
end
