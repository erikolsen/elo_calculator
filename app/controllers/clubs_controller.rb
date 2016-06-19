class ClubsController < ApplicationController
  def index
    @clubs = Club.all
    render layout: '_without_container'
  end

  def new
    @club = Club.new
  end

  def show
    @club = Club.find params[:id]
  end

  def create
    @club = Club.new(club_params)

    if @club.save
      redirect_to root_path, notice: 'Club created'
    else
      flash.now[:alert] = 'Club failed to save'
      render :new
    end
  end

  private

  def club_params
    params.require(:club).permit(:name)
  end
end
