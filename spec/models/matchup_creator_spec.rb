require 'rails_helper'
describe MatchupCreator do
  let!(:player_1) { Player.create name: 'Player 1' }
  let!(:player_2) { Player.create name: 'Player 2' }
  let(:primary_id) { player_1.id }
  let(:secondary_id) { player_2.id }
  let!(:matchup) { Matchup.create primary_id: primary_id, secondary_id: secondary_id }
  let(:game_results){ { '1' => secondary_id, '2' => secondary_id, '3' => primary_id, '4' => primary_id, '5' => primary_id } }

  let(:params) { { game_results: game_results, matchup_id: matchup.id } }

  subject { described_class.new params }

  context '#opponent_of' do
    it 'finds correct opponent for challenger' do
      expect(subject.opponent_of(primary_id)).to eq secondary_id
      expect(subject.opponent_of(secondary_id)).to eq primary_id
    end
  end

  context '#winner_id' do
    it 'returns the winners id' do
      subject.save
      expect(subject.winner_id).to be primary_id
    end

    it 'returns false if the games are equal' do
      game_results.delete('5')
      expect(subject.winner_id).to be false
    end
  end

  context '#save' do
    context 'valid matchup' do
      it 'creates the games' do
        subject.save
        expect(subject.matchup.winner).to eq player_1
        expect(subject.matchup.primary).to eq player_1
        expect(subject.matchup.secondary).to eq player_2
      end

      it 'creates games for each game in matchup' do
        subject.save
        expect(subject.matchup.games.count).to be 5
        expect(subject.matchup.games[0].winner.id).to be secondary_id
        expect(subject.matchup.games[1].winner.id).to be secondary_id
        expect(subject.matchup.games[2].winner.id).to be primary_id
        expect(subject.matchup.games[3].winner.id).to be primary_id
        expect(subject.matchup.games[4].winner.id).to be primary_id
      end
    end

    context 'invalid matchup' do
      context 'too many games in matchup' do
        let(:too_many_games_matchups){ {  '1' => '2', "2" => secondary_id,  "3" => secondary_id,  "4" => primary_id,  "5" => primary_id, "6" => primary_id } }
        let(:bad_params) { { game_results: too_many_games_matchups, matchup_id: matchup.id  } }
        subject { described_class.new bad_params }

        it 'does not save any games' do
          expect(subject.save).to be false
          expect(subject.matchup.games.count).to be 0
        end
      end

      context 'too many games in matchup' do
        let(:no_winner_matchups){ {  "1" => secondary_id,  "2" => secondary_id,  "3" => primary_id,  "4" => primary_id} }
        let(:bad_params) { { game_results: no_winner_matchups, matchup_id: matchup.id  } }
        subject { described_class.new bad_params }

        it 'does not save any games' do
          expect(subject.save).to be false
          expect(subject.matchup.games.count).to be 0
        end
      end
    end
  end
end
