# == Schema Information
#
# Table name: bracket_matchups
#
#  id                  :integer          not null, primary key
#  tournament_id       :integer
#  matchup_id          :integer
#  primary             :integer
#  secondary           :integer
#  winner_child        :integer
#  loser_child         :integer
#  tournament_sequence :integer
#  winner              :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_bracket_matchups_on_matchup_id     (matchup_id)
#  index_bracket_matchups_on_tournament_id  (tournament_id)
#
# Foreign Keys
#
#  fk_rails_...  (matchup_id => matchups.id)
#  fk_rails_...  (tournament_id => tournaments.id)
#

require 'rails_helper'

RSpec.describe BracketMatchup, type: :model do
  describe '#update_child' do
    let(:club) { FactoryGirl.create :club, member_count: 8 }
    let(:tournament_params) { { name: 'Some Tourney',
                                players: club.players.pluck(:id),
                                end_date: 1.week.from_now,
                                tournament_type: 'single_elimination' } }

    context 'updating child nodes' do
      before do
        creator = TournamentCreator.new(tournament_params)
        creator.save
        @tournament = creator.tournament

        @first_match = @tournament.bracket_matchups[0]
        @second_match = @tournament.bracket_matchups[1]
        @fifth_match = @tournament.bracket_matchups[4]

        @first_match.winner = @first_match.primary
        @second_match.winner = @second_match.primary

        @first_match.update_children!
        @second_match.update_children!

        @last_match = @tournament.bracket_matchups[6]
      end

      it 'does nothing if no children' do
        expect(@last_match.update_children!).to be nil
      end

      it 'sets the primary of its child' do
        expect(@first_match.winner).to eq @fifth_match.reload.primary
      end

      it 'sets the secondary of its child' do
        expect(@second_match.winner).to eq @fifth_match.reload.secondary
      end

      it 'sets the primary of its child matchup' do
        expect(@first_match.winner).to eq @fifth_match.matchup.primary.id
      end

      it 'sets the secondary of its child matchup' do
        expect(@second_match.winner).to eq @fifth_match.matchup.secondary.id
      end
    end

  end
end
