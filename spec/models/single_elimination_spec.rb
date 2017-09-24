require 'rails_helper'
RSpec.describe SingleElimination do
  describe '.build_matchups_for tournament' do
    let!(:player_1) { FactoryGirl.create :player, rating: 2000 }
    let!(:player_2) { FactoryGirl.create :player, rating: 1900 }
    let!(:player_3) { FactoryGirl.create :player, rating: 1800 }
    let!(:player_4) { FactoryGirl.create :player, rating: 1700 }
    let!(:player_5) { FactoryGirl.create :player, rating: 1600 }
    let!(:player_6) { FactoryGirl.create :player, rating: 1500 }
    let!(:player_7) { FactoryGirl.create :player, rating: 1400 }

    let(:tournament) { FactoryGirl.create(:tournament, type: 'SingleElimination') }

    before do
      tournament.players << Player.all
      SingleElimination.build_matchups_for tournament
      tournament.reload
    end

    describe 'bracket matchups' do
      subject { tournament.brackets }

      it 'creates next power of 2 from number of players includes 3rd and 4th place matchup' do
        expect(subject.count).to eq 8
      end

      it 'tournament sequence 1' do
        expect(subject[0].tournament_sequence).to eq 1
        expect(subject[0].winner).to eq player_1
        expect(subject[0].winner_child).to eq 5
        expect(subject[0].loser_child).to eq nil
        expect(subject[0].matchup).to eq nil
        expect(subject[0].matchup).to eq nil
        expect(subject[0].bracket_type).to eq 'winners'
      end

      it 'tournament sequence 2' do
        expect(subject[1].tournament_sequence).to eq 2
        expect(subject[1].winner_child).to eq 5
        expect(subject[1].loser_child).to eq nil
        expect(subject[1].matchup.primary_id).to eq player_4.id
        expect(subject[1].matchup.secondary_id).to eq player_5.id
        expect(subject[1].bracket_type).to eq 'winners'
      end

      it 'tournament sequence 3' do
        expect(subject[2].tournament_sequence).to eq 3
        expect(subject[2].winner_child).to eq 6
        expect(subject[2].loser_child).to eq nil
        expect(subject[2].matchup.primary_id).to eq player_2.id
        expect(subject[2].matchup.secondary_id).to eq player_7.id
        expect(subject[2].bracket_type).to eq 'winners'
      end

      it 'tournament sequence 4' do
        expect(subject[3].tournament_sequence).to eq 4
        expect(subject[3].winner_child).to eq 6
        expect(subject[3].loser_child).to eq nil
        expect(subject[3].matchup.primary_id).to eq player_3.id
        expect(subject[3].matchup.secondary_id).to eq player_6.id
        expect(subject[3].bracket_type).to eq 'winners'
      end

      it 'tournament sequence 5' do
        expect(subject[4].tournament_sequence).to eq 5
        expect(subject[4].winner_child).to eq 7
        expect(subject[4].loser_child).to eq 8
        expect(subject[4].bracket_type).to eq 'winners'
      end

      it 'tournament sequence 6' do
        expect(subject[5].tournament_sequence).to eq 6
        expect(subject[5].winner_child).to eq 7
        expect(subject[5].loser_child).to eq 8
        expect(subject[5].bracket_type).to eq 'winners'
      end

      it 'tournament sequence 7' do
        expect(subject[6].tournament_sequence).to eq 7
        expect(subject[6].winner_child).to eq nil
        expect(subject[6].loser_child).to eq nil
        expect(subject[6].bracket_type).to eq 'winners'
      end

      it 'tournament sequence 8' do
        expect(subject[7].tournament_sequence).to eq 8
        expect(subject[7].winner_child).to eq nil
        expect(subject[7].loser_child).to eq nil
        expect(subject[7].bracket_type).to eq 'losers'
      end

    end
  end
end
