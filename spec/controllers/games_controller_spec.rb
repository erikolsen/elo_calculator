require 'rails_helper'

describe GamesController do
  describe '#new' do
    let(:game_creator) { double 'game creator' }

    before do
      allow(GameCreator).to receive(:new) { game_creator }
    end

    it 'assigns new game' do
      get :new
      expect(assigns(:game)).to eq(game_creator)
    end
  end

  describe '#create' do
    let(:winner_id) { '1' }
    let(:loser_id) { '2' }
    let(:params) { { game: { winner_id: winner_id, loser_id: loser_id } } }
    let(:game_creator) { double 'game creator', save: save_success? }

    before do
      allow(GameCreator).to receive(:new).with(winner_id, loser_id) { game_creator }
      allow(game_creator).to receive(:game){ Game.new }
    end

    context 'success' do
      let(:save_success?) { true }
      
      it 'creates new game' do
        post :create, params
        expect(flash[:notice]).to eq('Game created')
        expect(response).to redirect_to(assigns(:game))
      end
    end

    context 'failure' do
      let(:save_success?) { false }
      let(:errors) { double 'errors', full_messages: full_messages }
      let(:full_messages) { [ 'error message 1', 'error message 2' ] }

      before do
        allow(game_creator).to receive(:errors) { errors }
      end

      it 'creates new game' do
        post :create, params
        expect(flash[:alert]).to eq(full_messages.join('. '))
        expect(response).to render_template(:new)
      end
    end
  end

  describe '#show' do
    let!(:winner) { Player.create(name: 'Winner', rating: 1000) } 
    let!(:loser) { Player.create(name: 'Loser', rating: 1000) } 
    let!(:game) { Game.create(winner_id: winner.id, 
                              loser_id: loser.id, 
                              winner_rating: winner.rating, 
                              loser_rating: loser.rating) }

    it 'shows the last game create' do
      get :show, id: game.id
      expect(response).to render_template(:show)
    end
  end
end
