class ClubsController < ApplicationController
  def index
    @clubs = Club.all
    @player_count = Player.count
    render layout: '_without_container'
  end

  def new
    @club = Club.new
  end

  def show
    @club = Club.find_by(slug:  club_name)
  end

  def create
    @club = Club.new(club_params)

    if @club.save
      redirect_to clubs_path
    else
      flash.now[:alert] = 'Club failed to save'
      render :new
    end
  end

  private

  def club_name
    params[:slug]
  end

  def club_params
    params.require(:club).permit(:name)
  end
end
