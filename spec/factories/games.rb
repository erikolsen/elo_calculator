#create_table "games", force: :cascade do |t|
#  t.integer  "winner_rating"
#  t.integer  "loser_rating"
#  t.datetime "created_at"
#  t.datetime "updated_at"
#  t.integer  "winner_id"
#  t.integer  "loser_id"
#  t.integer  "matchup_id"
#end

FactoryGirl.define do
  factory :game do
    winner_rating 1000
    loser_rating 1000
    created_at Date.today
    updated_at Date.today
    winner_id 1
    loser_id 2
    matchup_id nil
  end
end
