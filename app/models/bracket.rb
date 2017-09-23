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

class Bracket < ApplicationRecord
  belongs_to :tournament
  belongs_to :matchup
  belongs_to :winner, class_name: 'Player'

  delegate :primary, :secondary, to: :matchup

  def loser
    return nil if bye
    matchup.opponent_of winner
  end

  def ready?
    (primary && secondary) && !winner
  end

  def siblings
    tournament.brackets
  end

  def secondary_parent
    siblings.where(winner_child: tournament_sequence).last
  end

  def primary_parent
    siblings.where(winner_child: tournament_sequence).first
  end

  def loser_child_bracket
    siblings.where(tournament_sequence: loser_child).first
  end

  def winner_child_bracket
    siblings.where(tournament_sequence: winner_child).first
  end

  def update_children!
    return nil unless winner
    ordinal = tournament_sequence.odd? ? :primary_id : :secondary_id
    loser_child_bracket&.matchup&.update_column(ordinal, loser.id) if loser
    winner_child_bracket&.matchup&.update_column(ordinal, winner_id)
  end
end
