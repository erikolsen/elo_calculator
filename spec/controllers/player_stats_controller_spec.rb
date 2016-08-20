require 'rails_helper'

describe PlayerStatsController do
  let(:ratings_data) { [1, 2, 3, 4, 5] }
  let(:player) { double 'player', ratings_over_time: ratings_data }

  before do
    allow(subject).to receive(:player) { player }
  end

  describe '#show' do
    before do
      get :show, id: 123
    end

    it 'should return ratings over time' do
      expect(JSON.parse(response.body)).to eq(ratings_data)
    end
  end
end
