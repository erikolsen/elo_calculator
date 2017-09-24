require 'rails_helper'

RSpec.describe RoundRobin do
  describe '.build_matchups_for tournament' do
    let(:players) { (1..4).map { FactoryGirl.create(:player) } }
    let(:tournament) { FactoryGirl.create(:round_robin) }

    before do
      tournament.players << players
      tournament.build_matchups!
    end

    it 'creates all combinations of matches' do
      expect(tournament.matchups.count).to eq 6
    end
  end
end
