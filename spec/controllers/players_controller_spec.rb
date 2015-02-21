require 'rails_helper'

describe PlayersController do
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
