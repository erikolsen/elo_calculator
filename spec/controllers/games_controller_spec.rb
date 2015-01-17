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
    end

    context 'success' do
      let(:save_success?) { true }

      it 'creates new game' do
        post :create, params
        expect(flash[:notice]).to eq('Game created')
        expect(response).to redirect_to(root_path)
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
    let(:game) { double 'game' }

    it 'shows the last game create' do
      get :show, id: game
      expect(response).to render_template(:show)
    end
  end
end
