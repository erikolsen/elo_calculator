module Tournaments
  class EntriesController < ApplicationController
    before_action :set_tournament

    def index
    end

    def create
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

    def destroy
      @entry = Entry.where(tournament_id: entry_params[:tournament_id],
                           player_id: entry_params[:id]).first
      @entry.destroy
      redirect_to tournament_entries_path(@tournament), notice: "#{@entry.player.name} Withdrew"
    end

    private

    def set_tournament
      @tournament = Tournament.find(params[:tournament_id])
    end

    def entry_params
      params.permit(:id, :tournament_id)
    end

    def tournament_params
      params.require(:tournament).permit({ players: [] }, :players)
    end
  end
end
