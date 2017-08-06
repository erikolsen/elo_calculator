# == Schema Information
#
# Table name: entries
#
#  id            :integer          not null, primary key
#  tournament_id :integer
#  player_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_entries_on_player_id      (player_id)
#  index_entries_on_tournament_id  (tournament_id)
#

class Entry < ApplicationRecord
  belongs_to :tournament
  belongs_to :player
end
