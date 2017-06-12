module Players
  class RatingsController < ApplicationController

    def index
      @player = Player.find(params[:player_id])
    end

  end
end
