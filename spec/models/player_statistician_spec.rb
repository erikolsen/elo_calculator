require 'rails_helper'

describe PlayerStatistician do
  describe '#days_played' do
    let(:player_1) { FactoryGirl.create :player }
    let(:player_2) { FactoryGirl.create :player }
    let(:expected_days) { [1.day.ago, 1.week.ago, 1.month.ago ].map(&:to_date) }
    let(:statistician) { described_class.new(player_1) }

    before do
      2.times { FactoryGirl.create :game, winner_id: player_1.id, loser_id: player_2.id, created_at: 1.month.ago }
      2.times { FactoryGirl.create :game, winner_id: player_1.id, loser_id: player_2.id, created_at: 1.week.ago  }
      2.times { FactoryGirl.create :game, winner_id: player_1.id, loser_id: player_2.id, created_at: 1.day.ago  }
    end

    it 'returns an array of uniq days' do
      expect(statistician.days_played).to eq expected_days
    end
  end

  describe '#highest_rating_achieved' do
    context 'highest rating was a game you won' do
      let!(:player_1) { FactoryGirl.create :player  }
      let!(:player_2) { FactoryGirl.create :player  }

      before do
        GameCreator.new(player_1.id, player_2.id).save
        player_1.reload
      end

      it 'returns the current rating' do
        statistician = described_class.new(player_1)
        expect(statistician.highest_rating_achieved).to eq 1025
      end
    end

    context 'highest rating was a game you lost' do
      let!(:player_1) { FactoryGirl.create :player  }
      let!(:player_2) { FactoryGirl.create :player  }

      before do
        GameCreator.new(player_2.id, player_1.id).save
        player_1.reload
      end

      it 'returns the rating when you played the game' do
        statistician =  described_class.new(player_1)
        expect(statistician.highest_rating_achieved).to eq 1000
      end
    end
  end

  describe '#win_percentage' do
    let(:player_2) { FactoryGirl.create :player  }
    let(:player_1) { FactoryGirl.create :player  }

    context 'have not won games' do
      it 'returns 0' do
        statistician =  described_class.new(player_1)
        expect(statistician.win_percentage).to eq 0
      end
    end

    context 'have played games' do
      before do
        GameCreator.new(player_2.id, player_1.id).save
        GameCreator.new(player_2.id, player_1.id).save
        GameCreator.new(player_1.id, player_2.id).save
      end

      it 'returns the percent of games you win' do
        statistician = described_class.new(player_1)
        expect(statistician.win_percentage).to eq 33
      end

      it 'returns the percent of games you win' do
        statistician =  described_class.new(player_2)
        expect(statistician.win_percentage).to eq 67
      end
    end
  end

  describe '#opponents_by_games_played' do
    let(:player_2) { FactoryGirl.create :player }
    let(:player_1) { FactoryGirl.create :player }
    let(:player_3) { FactoryGirl.create :player }
    let(:player_4) { FactoryGirl.create :player }

    context 'have played no games' do
      it 'returns empty collection' do
        statistician =  described_class.new(player_1)
        expect(statistician.opponents_by_games_played).to eq []
      end
    end

    context 'have played games' do
      before do
        GameCreator.new(player_1.id, player_4.id).save
        GameCreator.new(player_1.id, player_2.id).save
        GameCreator.new(player_1.id, player_3.id).save
        GameCreator.new(player_1.id, player_3.id).save
        GameCreator.new(player_1.id, player_4.id).save
        GameCreator.new(player_1.id, player_4.id).save
        GameCreator.new(player_2.id, player_3.id).save
      end

      let(:expected_results) { [player_4,player_3,player_2] }
      it 'returns the id and number of games played' do
        statistician =  described_class.new(player_1)
        expect(statistician.opponents_by_games_played).to eq expected_results
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
          statistician = described_class.new(player_1)
          expect(statistician.rating_change_on(day)).to be expected_difference
        end
      end

      context 'have not played games since' do
        let!(:player_1) { FactoryGirl.create :player, rating: 1050 }
        let!(:games) { [*1..3].map { FactoryGirl.create :game, winner_id: player_1.id, loser_id: player_2.id } }
        let!(:day) { Date.current }

        it 'returns the difference between rating in first game and current rating' do
          statistician = described_class.new(player_1)
          expect(statistician.rating_change_on(day)).to be 50
        end
      end
    end

    context 'have not played games on day' do
      let!(:day) { 1.week.ago }
      let(:expected_difference) { 0 }
      let!(:prior_game) { FactoryGirl.create :game, winner_id: player_1.id, loser_id: player_2.id, created_at: 1.month.ago }
      let!(:later_game) { FactoryGirl.create :game, winner_id: player_1.id, loser_id: player_2.id, winner_rating: player_1.rating + 100 }

      it 'returns zero' do
        statistician =  described_class.new(player_1)
        expect(statistician.rating_change_on(day)).to be expected_difference
      end
    end
  end

  describe '#daily_rating_change' do
    let!(:player_1) { FactoryGirl.create :player }
    let!(:player_2) { FactoryGirl.create :player }

    context 'have played games' do
      before do
        GameCreator.new(player_2.id, player_1.id).save
        GameCreator.new(player_2.id, player_1.id).save
        GameCreator.new(player_2.id, player_1.id).save
      end

      it 'returns rating movment from first game to rating after last game' do
        statistician =  described_class.new(player_1.reload)
        expect(statistician.daily_rating_change).to eq -66
      end

      it 'returns rating movment from first game to rating after last game' do
        statistician =  described_class.new(player_2.reload)
        expect(statistician.daily_rating_change).to eq 66
      end
    end
  end

  describe '#average_rating' do
    let(:player_1) { FactoryGirl.create :player }
    let(:player_2) { FactoryGirl.create :player }

    context 'with no days played' do
      it 'should return zero' do
        statistician = described_class.new(player_1)
        expect(statistician.average_rating).to eq 1000
      end
    end

    context 'with 1 day played' do
      before do
        GameCreator.new(player_1.id, player_2.id).save
      end

      it 'should return current rating' do
        statistician = described_class.new(player_1.reload)
        expect(statistician.average_rating).to eq 1012
      end
    end

    context 'with more than 1 day played' do
      before do
        GameCreator.new(player_1.id, player_2.id).save
        GameCreator.new(player_1.id, player_2.id).save
      end

      it 'should return the average rating for the two days' do
        statistician = described_class.new(player_1.reload)
        expect(statistician.average_rating).to eq 1024
      end
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
      statistician =  described_class.new(player_1)
      expect(statistician.ratings_over_time).to eq(expected_data)
    end
  end
end
