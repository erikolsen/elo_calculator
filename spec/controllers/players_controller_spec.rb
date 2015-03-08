require 'rails_helper'

describe PlayersController do
  describe '#index' do
    let(:players) { double 'players' }

    before do
      allow(Player).to receive(:by_rating) { players }
    end

    it 'shows player rankings' do
      get :index
      expect(assigns(:players)).to eq(players)
    end
  end

  describe '#show' do
    let(:player) { double 'player' }
    let(:params) { { id: "5" } }

    before do
      allow(Player).to receive(:find).with(params[:id]) { player }
    end

    it 'assigns the player' do
      get :show, params
      expect(assigns(:player)).to eq(player)
    end
  end
end
