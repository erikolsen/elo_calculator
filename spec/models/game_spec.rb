require 'rails_helper'

describe Game do
  it { should belong_to(:winner).class_name('Player') }
  it { should belong_to(:loser).class_name('Player') }

  it { should validate_presence_of(:winner_id) }
  it { should validate_presence_of(:loser_id) }
  it { should validate_presence_of(:winner_rating) }
  it { should validate_presence_of(:loser_rating) }

  describe '#opponent_of player' do
    let(:player_1) { Player.create(name: 'Player 1', rating: 1000) }
    let(:player_2) { Player.create(name: 'Player 2', rating: 1000) }

    before do
      creator = GameCreator.new(player_1.id, player_2.id)
      creator.save
      @game = creator.game
    end

    it 'returns the opponent of a given player' do
      expect(@game.opponent_of(player_1)).to eq player_2
      expect(@game.opponent_of(player_2)).to eq player_1
    end
  end
end
