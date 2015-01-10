require 'rails_helper'

describe GameCreator do
  let(:winner_id) { double 'winner id' }
  let(:loser_id) { double 'loser id' }

  let(:winner_rating) { double 'winner rating' }
  let(:loser_rating) { double 'loser rating' }

  let(:winner) { double 'winner', id: winner_id, rating: winner_rating }
  let(:loser) { double 'loser', id: loser_id, rating: loser_rating }

  subject { described_class.new(winner_id, loser_id) }

  describe '#save' do
    let(:game) { double 'game' }

    let(:rating_updater) { double 'rating updater', change_in_rating: change_in_rating }
    let(:change_in_rating) { double 'change in rating' }

    before do
      allow(Game).to receive(:create!).with(winner_id: winner_id, loser_id: loser_id, winner_rating: winner_rating, loser_rating: loser_rating) { game }
      allow(Player).to receive(:find).with(winner_id) { winner }
      allow(Player).to receive(:find).with(loser_id) { loser }
      allow(RatingUpdater).to receive(:new).with(winner_rating, loser_rating) { rating_updater }

      allow(winner).to receive(:add_rating!)
      allow(loser).to receive(:subtract_rating!)
    end

    context 'valid' do
      it 'creates new game' do
        expect(subject.save).to eq(true)
      end

      it 'updates winner rating' do
        expect(winner).to receive(:add_rating!).with(change_in_rating)
        subject.save
      end

      it 'updates loser rating' do
        expect(loser).to receive(:subtract_rating!).with(change_in_rating)
        subject.save
      end
    end

    context 'invalid player ids' do
      let(:loser_id) { winner_id }

      it 'does not create new game' do
        expect(game).to_not receive(:create!)
        expect(winner).to_not receive(:add_rating!)
        expect(loser).to_not receive(:subtract_rating!)

        expect(subject.save).to eq(false)

        expect(subject.errors.full_messages).to eq([ 'Winner and loser cannot be same player' ])
      end
    end

    context 'transaction fails' do
      let(:errors) { double 'errors', full_messages: full_messages }
      let(:full_messages) { [ 'error 1', 'error 2' ] }

      let(:record) { Player.new }

      context 'winner fails to update rating' do
        before do
          allow(winner).to receive(:add_rating!).with(change_in_rating).and_raise(ActiveRecord::RecordInvalid.new(record))
        end

        it 'does not create new game' do
          expect(subject.save).to eq(false)
          expect(subject.errors.full_messages).to eq([ 'Failed to save game' ])
        end
      end

      context 'loser fails to update rating' do
        before do
          allow(loser).to receive(:subtract_rating!).with(change_in_rating).and_raise(ActiveRecord::RecordInvalid.new(record))
        end

        it 'does not create new game' do
          expect(subject.save).to eq(false)
          expect(subject.errors.full_messages).to eq([ 'Failed to save game' ])
        end
      end

      context 'game fails to save' do
        let(:record) { Game.new }

        before do
          allow(Game).to receive(:create!).with(winner_id: winner_id, loser_id: loser_id, winner_rating: winner_rating, loser_rating: loser_rating).and_raise(ActiveRecord::RecordInvalid.new(record))
        end

        it 'does not create new game' do
          expect(subject.save).to eq(false)
          expect(subject.errors.full_messages).to eq([ 'Failed to save game' ])
        end
      end
    end
  end
end
