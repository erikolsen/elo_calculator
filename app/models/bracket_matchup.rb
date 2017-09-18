# == Schema Information
#
# Table name: bracket_matchups
#
#  id                  :integer          not null, primary key
#  tournament_id       :integer
#  matchup_id          :integer
#  bracket_type        :string
#  primary_id          :integer
#  secondary_id        :integer
#  winner_child        :integer
#  loser_child         :integer
#  tournament_sequence :integer
#  winner_id           :integer
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
  belongs_to :winner, class_name: 'Player'

  def loser
    matchup.opponent_of winner
  end

  def ready?
    (primary_id && secondary_id) && !winner
  end

  def siblings
    tournament.bracket_matchups
  end

  def update_children!
    return nil unless winner
    ordinal = tournament_sequence.odd? ? :primary_id : :secondary_id
    if l= siblings.where(tournament_sequence: loser_child).first
      l.update_column(ordinal, loser.id)
      l.matchup.update_column(ordinal, loser.id)
    end
    if w = siblings.where(tournament_sequence: winner_child).first
      w.update_column(ordinal, winner_id)
      w.matchup.update_column(ordinal, winner_id)
    end
  end
end
