module Tournaments
  class EntriesController < ApplicationController
    def index
      @tournament = Tournament.find(params[:tournament_id])
    end

    def create
      @tournament = Tournament.find(params[:tournament_id])
      if tournament_params[:players].present?
        new_player = Player.find tournament_params[:players]
        @tournament.players << new_player
        redirect_to tournament_entries_path(@tournament), notice: "#{new_player.name} added!"
      else
        flash.now[:alert] = 'Failed to add player'
        flash.keep
        redirect_to tournament_entries_path(@tournament)
      end
    end

    private

    def tournament_params
      params.require(:tournament).permit({ players: [] }, :players)
    end
  end
end
