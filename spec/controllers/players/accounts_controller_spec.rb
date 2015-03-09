require 'rails_helper'

describe Players::AccountsController do
  describe '#new' do
    let(:account) { double 'account' }
    let(:player) { double 'player' }
    let(:player_id) { '1' }

    before do
      allow(Player).to receive(:find).with(player_id) { player }
      allow(Account).to receive(:new).with(player) { account }
    end

    it 'should assign an account' do
      get :new, player_id: player_id
      expect(assigns(:account)).to eq(account)
    end
  end
end
