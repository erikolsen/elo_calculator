require 'rails_helper'

describe PlayersController do
  describe '#show' do
    let(:games) { double 'games' }
    let(:pages) { double 'pages' }
    let(:player) { double 'player', id: 5, games: games  }
    let(:params) { { id: "5" } }

    before do
      allow(Player).to receive(:find).with(params[:id]) { player }
      allow(games).to receive(:page).with(params[:page]) { pages }
      allow(pages).to receive(:per).with(10)
    end

    it 'assigns the player' do
      get :show, params
      expect(assigns(:player)).to eq(player)
    end
  end
end
