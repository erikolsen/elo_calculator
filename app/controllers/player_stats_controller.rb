class PlayerStatsController < ApplicationController
  before_action :player_must_exist

  def index
    @stat = PlayerVsPlayer.new(primary, secondary)
    @games = @stat.games.page(params[:page]).per(10)
    render :index
  end

  def player_vs_player
    render json: PlayerVsPlayer.new(primary, secondary).games_won
  end

  def show
    render json: PlayerStatistician.new(player).ratings_over_time(params[:limit])
  end

  private

  def player_must_exist
    head :not_found unless player || (primary && secondary)
  end

  def primary
    @primary ||= Player.find_by(id: params[:primary])
  end

  def secondary
    @secondary ||= Player.find_by(id: params[:secondary])
  end

  def player
    @player || Player.find_by(id: params[:id])
  end
end
