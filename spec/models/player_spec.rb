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

  describe '#days_played' do
    let(:player_1) { FactoryGirl.create :player }
    let(:player_2) { FactoryGirl.create :player }
    let(:expected_days) { [1.day.ago, 1.week.ago, 1.month.ago ].map(&:to_date) }

    before do
      2.times { FactoryGirl.create :game, winner_id: player_1.id, loser_id: player_2.id, created_at: 1.month.ago }
      2.times { FactoryGirl.create :game, winner_id: player_1.id, loser_id: player_2.id, created_at: 1.week.ago  }
      2.times { FactoryGirl.create :game, winner_id: player_1.id, loser_id: player_2.id, created_at: 1.day.ago  }
    end

    it 'returns an array of uniq days' do
      expect(player_1.days_played).to eq expected_days
    end
  end

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

  describe '#top_five_opponents' do
    let(:player_2) { described_class.create(name: 'Player 2', rating: default_rating) }
    let(:player_1) { described_class.create(name: 'Player 1', rating: default_rating) }
    let(:player_3) { described_class.create(name: 'Player 3', rating: default_rating) }
    let(:player_4) { described_class.create(name: 'Player 4', rating: default_rating) }
    let(:default_rating) { 1000 }

    context 'have played no games' do
      it 'returns empty collection' do
        expect(player_1.top_five_opponents).to eq []
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
        expect(player_1.top_five_opponents).to eq expected_results
      end
    end
  end

  describe '#win_percentage' do
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

  describe '#rating_change_on(day)' do
    let(:player_1) { FactoryGirl.create :player }
    let(:player_2) { FactoryGirl.create :player }

    context 'have played games on day' do
      context 'have played games since' do
        let!(:day) { 1.week.ago }
        let(:expected_difference) { 100 }
        let!(:games) { [*1..3].map { FactoryGirl.create :game, winner_id: player_1.id, loser_id: player_2.id, created_at: day } }
        let!(:newer_games) { FactoryGirl.create :game, winner_id: player_1.id, loser_id: player_2.id, winner_rating: player_1.rating + expected_difference }

        it 'returns the difference between rating in first game and first game after requested day' do
          expect(player_1.rating_change_on(day)).to be expected_difference
        end
      end

      context 'have not played games since' do
        let!(:player_1) { FactoryGirl.create :player, rating: 1050 }
        let!(:games) { [*1..3].map { FactoryGirl.create :game, winner_id: player_1.id, loser_id: player_2.id } }
        let!(:day) { Date.current }

        it 'returns the difference between rating in first game and current rating' do
          expect(player_1.rating_change_on(day)).to be 50
        end
      end
    end

    context 'have not played games on day' do
      let!(:day) { 1.week.ago }
      let(:expected_difference) { 0 }
      let!(:prior_game) { FactoryGirl.create :game, winner_id: player_1.id, loser_id: player_2.id, created_at: 1.month.ago }
      let!(:later_game) { FactoryGirl.create :game, winner_id: player_1.id, loser_id: player_2.id, winner_rating: player_1.rating + 100 }

      it 'returns zero' do
        expect(player_1.rating_change_on(day)).to be expected_difference
      end
    end
  end

  describe '#daily_rating_change' do
    let!(:player_2) { described_class.create(name: 'Player 2', rating: default_rating) }
    let!(:player_1) { described_class.create(name: 'Player 1', rating: default_rating) }
    let(:default_rating) { 1000 }

    context 'have played games' do
      before do
        GameCreator.new(player_2.id, player_1.id).save
        GameCreator.new(player_2.id, player_1.id).save
        GameCreator.new(player_2.id, player_1.id).save
      end

      it 'returns rating movment from first game to rating after last game' do
        expect(player_2.reload.daily_rating_change).to eq 66
        expect(player_1.reload.daily_rating_change).to eq -66
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

  describe '#ratings_over_time' do
    let(:player_1) { FactoryGirl.create :player }
    let(:player_2) { FactoryGirl.create :player }

    let(:game1) { FactoryGirl.create :game, winner_id: player_1.id, loser_id: player_2.id, created_at: 1.month.ago }
    let(:game2) { FactoryGirl.create :game, winner_id: player_1.id, loser_id: player_2.id, created_at: 1.week.ago  }
    let(:game3) { FactoryGirl.create :game, winner_id: player_1.id, loser_id: player_2.id, created_at: 1.day.ago  }

    it 'should return back an array of all start ratings for user on the days they played games' do
      expected_data = [
        {x: game1.created_at.to_date, y: game1.winner_rating},
        {x: game2.created_at.to_date, y: game2.winner_rating},
        {x: game3.created_at.to_date, y: game3.winner_rating}
      ]
      expect(player_1.ratings_over_time).to eq(expected_data)
    end
  end
end
