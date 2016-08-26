require 'rails_helper'

describe 'PlayerStatsController' do
  let(:request_path) { player_stat_path player_id }

  describe 'GET /player_stats/:id' do
    context 'player exists' do
      let!(:player) { Player.create! name: 'john' }
      let!(:player_id) { player.id }

      it 'should return a 200' do
        get request_path

        expect(response.status).to eq(200)
      end
    end

    context 'player does not exist' do
      let(:player_id) { 999 }

      it 'should return a 404' do
        get request_path

        expect(response.status).to eq(404)
      end
    end
  end
end
