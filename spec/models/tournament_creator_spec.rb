require 'rails_helper'

describe TournamentCreator do
  let!(:player_1) { Player.create name: 'Player 1' }
  let!(:player_2) { Player.create name: 'Player 2' }
  let(:players_ids) { [player_1.id, player_2.id] }
  let(:tournament_name) { 'Some Name' }
  let(:end_date) { 1.week.from_now }
  let(:tournament_type) { 'round_robin' }
  let(:params) { { name: tournament_name,
                   players: players_ids,
                   tournament_type: tournament_type,
                   end_date: end_date }}


  describe '#valid?' do
    context '#has_tournament_type' do
      let(:tournament_type) { nil }
      subject { TournamentCreator.new(params)}

      it 'returns false if tournament has no type' do
        expect(subject.save).to be false
      end
    end
  end

  describe '#save' do
    subject { TournamentCreator.new(params)}

    context 'valid tournament' do
      before do
        subject.save
      end

      it 'returns the tournament with the correct number of entries' do
        expect(subject.tournament.players.count).to be 2
      end

      it 'sets the tournaments name' do
        expect(subject.tournament.name).to eq tournament_name
      end

      it 'sets the tournaments type' do
        expect(subject.tournament.tournament_type).to eq tournament_type
      end
    end
  end
end
