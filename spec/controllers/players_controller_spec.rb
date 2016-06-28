require 'rails_helper'

describe PlayersController do
  describe '#show' do
    let(:games) { double 'games' }
    let(:tournaments) { double 'tournaments' }
    let(:games_page) { double 'games_page' }
    let(:tournaments_page) { double 'tournaments_page' }
    let(:player) { double 'player', id: 5, games: games, tournaments: tournaments  }
    let(:params) { { id: "5" } }

    before do
      allow(Player).to receive(:find).with(params[:id]) { player }
      allow(games).to receive(:page).with(params[:games_page]) { games_page  }
      allow(games_page).to receive(:per).with(10)
      allow(tournaments).to receive(:page).with(params[:tournaments_page]) { tournaments_page }
      allow(tournaments_page).to receive(:per).with(10)
    end

    it 'assigns the player' do
      get :show, params
      expect(assigns(:player)).to eq(player)
    end
  end
end
