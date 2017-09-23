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
#  index_brackets_on_matchup_id     (matchup_id)
#  index_brackets_on_tournament_id  (tournament_id)
#
# Foreign Keys
#
#  fk_rails_...  (matchup_id => matchups.id)
#  fk_rails_...  (tournament_id => tournaments.id)
#

FactoryGirl.define do
  factory :bracket do

  end
end
