require 'rails_helper'

describe TournamentCreator do
  describe '#save' do
    let!(:player_1) { Player.create name: 'Player 1' }
    let!(:player_2) { Player.create name: 'Player 2' }
    let(:players_ids) { [player_1.id, player_2.id] }
    let(:tournament_name) { 'Some Name' }

    context 'valid tournament' do
      let!(:new_tournament)  { TournamentCreator.new(tournament_name, players_ids).save }
      it 'returns the tournament with the correct number of entries' do
        expect(new_tournament.entries.count).to be 2
      end

      it 'sets the tournaments name' do
        expect(new_tournament.name).to eq tournament_name
      end
    end
  end
end
