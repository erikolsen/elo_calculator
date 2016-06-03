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
