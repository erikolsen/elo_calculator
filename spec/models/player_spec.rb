require 'rails_helper'

describe Player do
  it { should have_many(:won_games).with_foreign_key('winner_id').class_name('Game') }
  it { should have_many(:lost_games).with_foreign_key('loser_id').class_name('Game') }

  it { should validate_presence_of :name }
  it { should validate_presence_of :rating }

  let(:id) { 1 }
  let(:name) { 'player name' }
  let(:rating) { 50 }

  subject { described_class.new(id: id, name: name, rating: rating) }

  describe 'updating rating methods' do
    let(:change_in_rating) { 25 }

    describe '#add_rating!' do
      let(:new_rating) { rating + change_in_rating }

      it 'adds rating to user' do
        subject.add_rating!(change_in_rating)
        expect(subject.reload.rating).to eq(new_rating)
      end
    end

    describe '#highest_rating_achieved' do
      let(:default_rating) { 1000 }
      let(:player_2) { described_class.create(name: 'Player 2', rating: default_rating) }
      subject { described_class.create(name: name, rating: default_rating) }

      context 'highest rating was a game you won' do
        before do
          GameCreator.new(subject.id, player_2.id).save
        end

        it 'returns the current rating' do
          expect(subject.reload.highest_rating_achieved).to eq 1025
        end
      end

      context 'highest rating was a game you lost' do
        before do
          GameCreator.new(player_2.id, subject.id).save
        end

        it 'returns the rating when you played the game' do
          expect(subject.reload.highest_rating_achieved).to eq 1000
        end
      end
    end

    describe '#subtract_rating!' do
      let(:new_rating) { rating - change_in_rating }

      it 'subtracts rating from user' do
        subject.subtract_rating!(change_in_rating)
        expect(subject.reload.rating).to eq(new_rating)
      end
    end
  end

  describe '#win_percentage' do
    let(:player_2) { described_class.create(name: 'Player 2', rating: default_rating) }
    let(:player_1) { described_class.create(name: 'Player 1', rating: default_rating) }
    let(:default_rating) { 1000 }

    context 'have not won games' do
      it 'returns 0' do
        expect(player_1.win_percentage).to eq 0
      end
    end

    context 'have played games' do
      before do
        GameCreator.new(player_2.id, player_1.id).save
        GameCreator.new(player_2.id, player_1.id).save
        GameCreator.new(player_1.id, player_2.id).save
      end
      it 'returns the percent of games you win' do
        expect(player_1.win_percentage).to eq 33
        expect(player_2.win_percentage).to eq 67
      end
    end
  end

  describe '#opponents_by_games_played' do
    let(:player_2) { described_class.create(name: 'Player 2', rating: default_rating) }
    let(:player_1) { described_class.create(name: 'Player 1', rating: default_rating) }
    let(:player_3) { described_class.create(name: 'Player 3', rating: default_rating) }
    let(:player_4) { described_class.create(name: 'Player 4', rating: default_rating) }
    let(:default_rating) { 1000 }

    context 'have played no games' do
      it 'returns empty collection' do
        expect(player_1.opponents).to eq []
      end
    end

    context 'have played games' do
      before do
        GameCreator.new(player_1.id, player_2.id).save
        GameCreator.new(player_1.id, player_3.id).save
        GameCreator.new(player_1.id, player_4.id).save
        GameCreator.new(player_1.id, player_4.id).save
        GameCreator.new(player_2.id, player_3.id).save
      end

      let(:expected_results) { [player_4,player_3,player_2] }
      it 'returns the id and number of games played' do
        expect(player_1.opponents_by_games_played).to eq expected_results
      end
    end
  end

  describe '#most_frequent_opponent' do
    let(:player_2) { described_class.create(name: 'Player 2', rating: default_rating) }
    let(:player_1) { described_class.create(name: 'Player 1', rating: default_rating) }
    let(:default_rating) { 1000 }

    context 'have played games' do
      before do
        GameCreator.new(player_2.id, player_1.id).save
        GameCreator.new(player_2.id, player_1.id).save
        GameCreator.new(player_1.id, player_2.id).save
      end
      it 'returns the player you played the most' do
        expect(player_1.win_percentage).to eq 33
        expect(player_2.win_percentage).to eq 67
      end
    end
  end




  describe '#games' do
    let(:games) { double 'games' }
    let(:ordered_games) { double 'ordered games' }

    before do
      allow(Game).to receive(:for_player).with(id) { games }
      allow(games).to receive(:most_recent) { ordered_games }
    end

    it 'should know its played games' do
      expect(subject.games).to eq(ordered_games)
    end
  end
end
