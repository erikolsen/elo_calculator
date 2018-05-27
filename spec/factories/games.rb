# == Schema Information
#
# Table name: games
#
#  id            :integer          not null, primary key
#  winner_rating :integer
#  loser_rating  :integer
#  created_at    :datetime
#  updated_at    :datetime
#  winner_id     :integer
#  loser_id      :integer
#  matchup_id    :integer
#
# Indexes
#
#  index_games_on_loser_id    (loser_id)
#  index_games_on_matchup_id  (matchup_id)
#  index_games_on_winner_id   (winner_id)
#

#create_table "games", force: :cascade do |t|
#  t.integer  "winner_rating"
#  t.integer  "loser_rating"
#  t.datetime "created_at"
#  t.datetime "updated_at"
#  t.integer  "winner_id"
#  t.integer  "loser_id"
#  t.integer  "matchup_id"
#end

FactoryBot.define do
  factory :game do
    winner_rating 1000
    loser_rating 1000
    created_at Date.current
    updated_at Date.current
    winner_id 1
    loser_id 2
    matchup_id nil
  end
end
