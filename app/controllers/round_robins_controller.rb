class RoundRobinsController < ApplicationController
  def show
    @tournament = RoundRobin.find(params[:id])
    @player = Player.find(params[:player]) if params[:player]
  end
end
