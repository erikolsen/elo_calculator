module Players
  class ClubsController < ApplicationController

    def index
      @player = Player.find(params[:player_id])
      @clubs = @player.clubs
    end

  end
end
