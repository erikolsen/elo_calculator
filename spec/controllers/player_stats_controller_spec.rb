require 'rails_helper'

describe PlayerStatsController do
  let(:ratings_data) { [1, 2, 3, 4, 5] }
  let(:player) { FactoryGirl.create :player }
  let(:statistician) { double 'statistician' }

  before do
    allow(PlayerStatistician).to receive(:new).with(player) { statistician }
    allow(statistician).to receive(:ratings_over_time) { ratings_data }
  end

  describe '#show' do
    before do
      get :show, id: player.id
    end

    it 'should return ratings over time' do
      expect(JSON.parse(response.body)).to eq(ratings_data)
    end
  end
end
