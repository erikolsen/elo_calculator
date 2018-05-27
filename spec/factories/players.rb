# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  rating     :integer          default(0), not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_players_on_name    (name)
#  index_players_on_rating  (rating)
#

#create_table "players", force: :cascade do |t|
#  t.string   "name"
#  t.integer  "rating",     default: 0, null: false
#  t.datetime "created_at"
#  t.datetime "updated_at"
#end
FactoryBot.define do
  factory :player do
    sequence(:name) { |n| "Player_#{n}" }
    rating 1000
    created_at Date.current
    updated_at Date.current
  end
end
