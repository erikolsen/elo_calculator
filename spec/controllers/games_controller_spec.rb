require 'rails_helper'

describe GamesController do
  describe '#new' do
    it 'assigns new game' do
      get :new
      expect(response).to render_template(:new)
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
    let(:game_id) { 'some game id' }
    let(:game) { double 'game', id: game_id }

    before do
      allow(Game).to receive(:find).with(game_id) { game }
    end

    it 'shows the last game create' do
      get :show, id: game_id
      expect(assigns(:game)).to eq(game)
      expect(response).to render_template(:show)
    end
  end
end
