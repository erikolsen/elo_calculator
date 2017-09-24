# == Schema Information
#
# Table name: brackets
#
#  id                  :integer          not null, primary key
#  tournament_id       :integer
#  matchup_id          :integer
#  bye                 :boolean          default(FALSE)
#  bracket_type        :string
#  winner_child        :integer
#  loser_child         :integer
#  tournament_sequence :integer
#  winner_id           :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_brackets_on_matchup_id           (matchup_id)
#  index_brackets_on_tournament_id        (tournament_id)
#  index_brackets_on_tournament_sequence  (tournament_sequence)
#
# Foreign Keys
#
#  fk_rails_...  (matchup_id => matchups.id)
#  fk_rails_...  (tournament_id => tournaments.id)
#

require 'rails_helper'

RSpec.describe Bracket, type: :model do
  describe '#update_child' do
    let(:club) { FactoryGirl.create :club, member_count: 8 }
    let(:tournament_params) { { name: 'Some Tourney',
                                players: club.players.pluck(:id),
                                end_date: 1.week.from_now,
                                type: 'SingleElimination' } }

    context 'updating child nodes' do
      before do
        creator = TournamentCreator.new(tournament_params)
        creator.save
        @tournament = creator.tournament

        @first_bracket = @tournament.brackets[0]
        @second_bracket = @tournament.brackets[1]
        @fifth_bracket = @tournament.brackets[4]

        @first_bracket.winner_id = @first_bracket.matchup.primary_id
        @second_bracket.winner_id = @second_bracket.matchup.primary_id

        @first_bracket.update_children!
        @second_bracket.update_children!

        @last_bracket = @tournament.brackets[6]
      end

      it 'does nothing if no children' do
        expect(@last_bracket.update_children!).to be nil
      end

      it 'sets the primary of its child' do
        expect(@first_bracket.winner_id).to eq @fifth_bracket.matchup.primary_id
      end

      it 'sets the secondary of its child' do
        expect(@second_bracket.winner_id).to eq @fifth_bracket.matchup.secondary_id
      end

      it 'sets the primary of its child matchup' do
        expect(@first_bracket.winner).to eq @fifth_bracket.matchup.primary
      end

      it 'sets the secondary of its child matchup' do
        expect(@second_bracket.winner).to eq @fifth_bracket.matchup.secondary
      end
    end

  end
end
