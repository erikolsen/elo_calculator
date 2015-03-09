module Players
  class AccountsController < ApplicationController
    def new
      @player = Player.find(params[:player_id])
      @account = Account.new(@player)
    end
  end
end
