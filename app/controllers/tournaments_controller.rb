class TournamentsController < ApplicationController
  def index
  end

  def new
    @tournament = Tournament.new
  end
end
