require 'rails_helper'
describe MatchupCreator do
  let!(:player_1) { Player.create name: 'Player 1' }
  let!(:player_2) { Player.create name: 'Player 2' }
  let!(:tournament) { Tournament.create name: 'Some Tournament' }
  let(:primary_id) { player_1.id }
  let(:secondary_id) { player_2.id }
  let(:matchups){ {  "game_1" => secondary_id,  "game_2" => secondary_id,  "game_3" => primary_id,  "game_4" => primary_id, "game_5" => primary_id } }

  let(:params) { { "tournament_matchups"=> matchups,"primary_id"=> primary_id, "secondary_id"=> secondary_id, "tournament_id" => tournament.id } }

  subject { described_class.new params }

  context '#new' do
    context 'parsing params' do
      it 'sets the matchups' do
        expect(subject.matchups).to eq matchups
      end
      it 'sets the primary' do
        expect(subject.primary_id).to eq primary_id
      end
      it 'sets the secondary' do
        expect(subject.secondary_id).to eq secondary_id
      end
    end
  end

  context '#opponent_of' do
    it 'finds correct opponent for challenger' do
      expect(subject.opponent_of(primary_id)).to eq secondary_id
      expect(subject.opponent_of(secondary_id)).to eq primary_id
    end
  end

  context '#winner_id' do
    it 'returns false if the games are equal' do
      expect(subject.winner_id). to be false
    end

    it 'returns the winners id' do
      subject.save
      expect(subject.winner_id).to be primary_id
    end
  end

  context '#save' do
    context 'valid matchup' do
      it 'creates the matchup' do
        subject.save
        tournament = Tournament.find(subject.tournament_id)

        expect(tournament.matchups.first.winner).to be primary_id
        expect(tournament.matchups.first.primary).to be primary_id
        expect(tournament.matchups.first.secondary).to be secondary_id
      end

      it 'creates games for each game in matchup' do
        subject.save
        expect(Game.count).to be 5
        expect(Game.all[0].winner.id).to be secondary_id
        expect(Game.all[1].winner.id).to be secondary_id
        expect(Game.all[2].winner.id).to be primary_id
        expect(Game.all[3].winner.id).to be primary_id
        expect(Game.all[4].winner.id).to be primary_id
      end
    end

    context 'invalid matchup' do
      context 'too many games in matchup' do
        let(:too_many_games_matchups){ {  'bad_game' => '2', "game_1" => secondary_id,  "game_2" => secondary_id,  "game_3" => primary_id,  "game_4" => primary_id, "game_5" => primary_id } }
        let(:bad_params) { { "tournament_matchups"=> too_many_games_matchups,"primary_id"=> primary_id, "secondary_id"=> secondary_id } }
        subject { described_class.new bad_params }

        it 'does not save any games' do
          expect(subject.save).to be false
          expect(Game.count).to be 0
        end
      end

      context 'too many games in matchup' do
        let(:no_winner_matchups){ {  "game_1" => secondary_id,  "game_2" => secondary_id,  "game_3" => primary_id,  "game_4" => primary_id} }
        let(:bad_params) { { "tournament_matchups"=> no_winner_matchups,"primary_id"=> primary_id, "secondary_id"=> secondary_id } }
        subject { described_class.new bad_params }

        it 'does not save any games' do
          expect(subject.save).to be false
          expect(Game.count).to be 0
        end
      end
    end
  end
end
