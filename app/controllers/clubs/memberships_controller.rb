module Clubs
  class MembershipsController < ApplicationController
    def index
      @players = Club.find_by(slug: params[:club_id])&.players || Player.all
      respond_to do |format|
        format.json { render json: @players.order('name asc')}
      end
    end

    def new
      @club = Club.find params[:club_id]
      @membership = Membership.new
    end

    def create
      @membership = Membership.new membership_params
      if @membership.save
        redirect_to club_path @membership.club, notice: 'Player Joined'
      else
        flash.now[:alert] = 'Player failed to join'
        render :new
      end
    end

    private

    def membership_params
      params.require(:membership).permit(:player_id, :club_id)
    end
  end
end
