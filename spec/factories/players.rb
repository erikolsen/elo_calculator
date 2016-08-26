#create_table "players", force: :cascade do |t|
#  t.string   "name"
#  t.integer  "rating",     default: 0, null: false
#  t.datetime "created_at"
#  t.datetime "updated_at"
#end
FactoryGirl.define do
  factory :player do
    sequence(:name) { |n| "Player_#{n}" }
    rating 1000
    created_at Date.today
    updated_at Date.today
  end
end
