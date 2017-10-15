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
#  start_date :datetime
#  club_id    :integer
#
# Indexes
#
#  index_tournaments_on_club_id  (club_id)
#  index_tournaments_on_type     (type)
#

require 'rails_helper'

RSpec.describe RoundRobin do
  describe '#build_matchups!' do
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
