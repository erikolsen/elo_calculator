require 'rails_helper'

RSpec.describe Tournament, :type => :model do
  let(:name) { 'Some Name' }
  let(:players) { Array.new(5) { Player.create(name: Faker::Name.first_name) } }

  before do
    creator = TournamentCreator.new(name, players)
    creator.save
    @tournament = creator.tournament
  end

  describe '#add_player' do
    let(:new_player) { Player.create name: 'Player 1' }
    context 'successfully adds player' do
      it 'builds the matches for the player' do
        expect(@tournament.matchups.count).to be 10
        expect(@tournament.players.count).to be 5
        @tournament.add_player new_player
        expect(@tournament.matchups.count).to be 15
        expect(@tournament.players.count).to be 6
      end
    end
  end
end
