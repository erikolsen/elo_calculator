require 'rails_helper'

describe HomepageController do
  describe '#show' do
    let(:players) { double 'players' }

    before do
      allow(Player).to receive(:for_homepage) { players }
    end

    it 'gets players by rating' do
      get :show
      expect(assigns(:players)).to eq(players)
    end
  end
end
