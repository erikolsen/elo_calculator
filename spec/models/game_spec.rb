require 'rails_helper'

describe Game do
  #it { should belong_to(:winner).class_name('Player') }
  #it { should belong_to(:loser).class_name('Player') }

  #it { should validate_presence_of(:winner_id) }
  #it { should validate_presence_of(:loser_id) }
  #it { should validate_presence_of(:winner_rating) }
  #it { should validate_presence_of(:loser_rating) }

  let(:player_1) { Player.create(name: 'Player 1', rating: 1000) }
  let(:player_2) { Player.create(name: 'Player 2', rating: 1000) }
  let(:player_3) { Player.create(name: 'Player 3', rating: 1000) }

  describe '.for_players' do
    before do
      GameCreator.new(player_3.id, player_2.id).save
      creator = GameCreator.new(player_1.id, player_2.id)
      creator.save
      @game = creator.game
    end

    it 'returns the games for two players' do
      expect(Game.for_players(player_1, player_2)).to eq [@game]
    end
  end

  describe '#next_game_for(player)' do
    before do
      creator = GameCreator.new(player_1.id, player_2.id)
      creator.save
      @game1 = creator.game
      GameCreator.new(player_2.id, player_3.id)
      creator = GameCreator.new(player_1.id, player_2.id)
      creator.save
      @game2 = creator.game
    end
    it 'returns the next game played for a given player' do
      expect(@game1.next_game_for(player_1)).to eq @game2
    end
  end

  describe '#opponent_of player' do
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
