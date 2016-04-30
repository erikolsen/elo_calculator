class TournamentsController < ApplicationController
  def index
  end

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new tournament_params
    if @tournament.save
      redirect_to @tournament, notice: 'Tournament created'
    else
      flash.now[:alert] = 'Tournament failed to save'
      render :new
    end
  end

  def show
    @tournament = Tournament.find(params[:id])
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, { players: [] })
  end
end
