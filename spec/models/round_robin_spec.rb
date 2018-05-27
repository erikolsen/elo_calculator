# == Schema Information
#
# Table name: tournaments
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#  end_date   :datetime
#  type       :string
#  series_max :integer
#
# Indexes
#
#  index_tournaments_on_type  (type)
#

require 'rails_helper'

RSpec.describe RoundRobin do
  describe '#build_matchups!' do
    let(:players) { (1..4).map { FactoryBot.create(:player) } }
    let(:series_max) { 5 }
    let(:tournament) { FactoryBot.create(:round_robin, series_max: series_max) }

    before do
      tournament.players << players
      tournament.build_matchups!
    end

    it 'creates matches with proper series max' do
      expect(tournament.matchups.pluck(:series_max).uniq).to eq [series_max]
    end

    it 'creates all combinations of matches' do
      expect(tournament.matchups.count).to eq 6
    end
  end
end
