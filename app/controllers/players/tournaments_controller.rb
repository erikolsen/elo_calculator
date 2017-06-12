module Players
  class TournamentsController < ApplicationController

    def index
      @player = Player.find(params[:player_id])
      @tournaments = @player.tournaments.page(params[:tournaments_page]).per(10)
    end

  end
end
