require 'rails_helper'

describe PlayerVsPlayer do
  let(:primary) { FactoryBot.create :player }
  let(:secondary) { FactoryBot.create :player }
  let(:day) { DateTime.now.beginning_of_month.strftime('%m/%d/%y') }
  subject { PlayerVsPlayer.new(primary, secondary) }

  context '#games_won' do
    let(:expected_games_won) { [{x: day, y: 1}, {x: day, y: 3}] }

    before do
      3.times { GameCreator.new(primary.id, secondary.id).save }
      GameCreator.new(secondary.id, primary.id).save
    end

    it 'returns the games won each day played' do
      expect(subject.games_won).to include expected_games_won
    end
  end
end
