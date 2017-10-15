class TournamentsController < ApplicationController
  def index
    @active_tournaments = Tournament.active
    @expired_tournaments = Tournament.expired
  end

  def new
    @tournament = Tournament.new
  end

  def create
    creator = TournamentCreator.new(tournament_params)
    if creator.save
      @tournament = creator.tournament
      redirect_to tournament_entries_path(@tournament), notice: 'Tournament created'
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

  def close_registration
    @tournament = Tournament.find(params[:id])
    if @tournament.build_matchups!
      redirect_to @tournament, notice: 'Tournament Started'
    else
      flash.now[:alert] = 'Failed to start tournament'
      flash.keep
      redirect_to tournament_registration_path(@tournament)
    end
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, :type, :start_date, :end_date, { players: [] }, :players)
  end
end
