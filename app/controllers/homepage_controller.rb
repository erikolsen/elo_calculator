class HomepageController < ApplicationController
  def show
    @players = Player.for_homepage
  end
end
