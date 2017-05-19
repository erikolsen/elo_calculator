#create_table "clubs", force: :cascade do |t|
  #t.string   "name"
  #t.string   "slug"
  #t.datetime "created_at", null: false
  #t.datetime "updated_at", null: false
#end
FactoryGirl.define do
  factory :club do
    name { Faker::StarWars.planet }
    created_at Date.current
    updated_at Date.current
  end
end
