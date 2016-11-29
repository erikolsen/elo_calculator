class PlayerStatsController < ApplicationController
  before_filter :player_must_exist

  def show
    render json: PlayerStatistician.new(player).ratings_over_time
  end

  private

  def player_must_exist
    render nothing: true, status: :not_found unless player
  end

  def player
    @player || Player.find_by_id(params[:id])
  end
end
