# == Schema Information
#
# Table name: brackets
#
#  id                  :integer          not null, primary key
#  tournament_id       :integer
#  matchup_id          :integer
#  is_bye              :boolean          default(FALSE)
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
#  index_brackets_on_matchup_id     (matchup_id)
#  index_brackets_on_tournament_id  (tournament_id)
#
# Foreign Keys
#
#  fk_rails_...  (matchup_id => matchups.id)
#  fk_rails_...  (tournament_id => tournaments.id)
#

class Bracket < ApplicationRecord
  belongs_to :tournament
  belongs_to :matchup
  belongs_to :winner, class_name: 'Player'

  def loser
    matchup.opponent_of winner
  end

  def ready?
    (matchup.primary_id && matchup.secondary_id) && !winner
  end

  def siblings
    tournament.brackets
  end

  def update_children!
    return nil unless winner
    ordinal = tournament_sequence.odd? ? :primary_id : :secondary_id
    if l= siblings.where(tournament_sequence: loser_child).first
      l.matchup.update_column(ordinal, loser.id)
    end
    if w = siblings.where(tournament_sequence: winner_child).first
      w.matchup.update_column(ordinal, winner_id)
    end
  end
end
