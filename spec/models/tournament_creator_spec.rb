require 'rails_helper'

describe TournamentCreator do
  describe '#save' do
    let!(:player_1) { Player.create name: 'Player 1' }
    let!(:player_2) { Player.create name: 'Player 2' }
    let(:players_ids) { [player_1.id, player_2.id] }
    let(:tournament_name) { 'Some Name' }
    let(:end_date) { 1.week.from_now }
    let(:params) { { name: tournament_name,
                     players: players_ids,
                     end_date: end_date }}

    context 'valid tournament' do
      subject { TournamentCreator.new(params)}

      before do
        subject.save
      end

      it 'returns the tournament with the correct number of entries' do
        expect(subject.tournament.players.count).to be 2
      end

      it 'sets the tournaments name' do
        expect(subject.tournament.name).to eq tournament_name
      end
    end
  end
end
