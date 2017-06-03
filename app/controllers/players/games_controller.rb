module Players
  class GamesController < ApplicationController

    def index
      @player = Player.find(params[:player_id])
      @games = @player.games.page(params[:games_page]).per(10)
    end

  end
end
