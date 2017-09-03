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

class BracketMatchup < ApplicationRecord
  belongs_to :tournament
  belongs_to :matchup

  def siblings
    tournament.bracket_matchups
  end

  def update_children!
    ordinal = tournament_sequence.odd? ? :primary : :secondary
    child = siblings.where(tournament_sequence: winner_child).first
    if child
      child.update_column(ordinal, winner)
      child.matchup.update_column(ordinal.to_s + '_id', winner)
    end
  end
end
