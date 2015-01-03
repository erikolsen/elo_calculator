class WelcomeController < ApplicationController
  def index
    @players = Player.all
  end
end
