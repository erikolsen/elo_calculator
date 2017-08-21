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

    let(:tournament) { FactoryGirl.create(:tournament, tournament_type: 'single_elimination') }

    before do
      tournament.players << Player.all
      SingleElimination.build_matchups_for tournament
    end

    describe 'bracket matchups' do
      subject { tournament.bracket_matchups }

      it 'creates next power of 2 from number of players minus 1 bracket matchups' do
        expect(subject.count).to eq 7
      end

      it 'tournament sequence 1' do
        expect(subject[0].tournament_sequence).to eq 1
        expect(subject[0].primary).to eq player_1.id.to_s
        expect(subject[0].secondary).to eq 'BYE'
      end

      it 'tournament sequence 2' do
        expect(subject[1].tournament_sequence).to eq 2
        expect(subject[1].primary).to eq player_4.id.to_s
        expect(subject[1].secondary).to eq player_5.id.to_s
      end

      it 'tournament sequence 3' do
        expect(subject[2].tournament_sequence).to eq 3
        expect(subject[2].primary).to eq player_2.id.to_s
        expect(subject[2].secondary).to eq player_7.id.to_s
      end

      it 'tournament sequence 4' do
        expect(subject[3].tournament_sequence).to eq 4
        expect(subject[3].primary).to eq player_3.id.to_s
        expect(subject[3].secondary).to eq player_6.id.to_s
      end

      it 'tournament sequence 5' do
        expect(subject[4].tournament_sequence).to eq 5
        expect(subject[4].primary_parent).to eq 1
        expect(subject[4].secondary_parent).to eq 2
      end

      it 'tournament sequence 6' do
        expect(subject[5].tournament_sequence).to eq 6
        expect(subject[5].primary_parent).to eq 3
        expect(subject[5].secondary_parent).to eq 4
      end

      it 'tournament sequence 7' do
        expect(subject[6].tournament_sequence).to eq 7
        expect(subject[6].primary_parent).to eq 5
        expect(subject[6].secondary_parent).to eq 6
      end

    end
  end
end

# BracketMatchup
# id
# tournament_id
# matchup_id
# primary
# secondary
# primary_parent
# secondary_parent
# tournament_sequence
#
# 1 bye
# 4 5
# 2 7
# 3 6
