# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  player_id  :integer
#  club_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_memberships_on_club_id    (club_id)
#  index_memberships_on_player_id  (player_id)
#
# Foreign Keys
#
#  fk_rails_...  (club_id => clubs.id)
#  fk_rails_...  (player_id => players.id)
#

class Membership < ApplicationRecord
  belongs_to :player
  belongs_to :club
end
