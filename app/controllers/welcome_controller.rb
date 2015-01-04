class WelcomeController < ApplicationController
  def index
    @players = Player.all.sort_by(:rating).reverse
  end
end
