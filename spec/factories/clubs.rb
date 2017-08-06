# == Schema Information
#
# Table name: clubs
#
#  id         :integer          not null, primary key
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_clubs_on_slug  (slug)
#

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

    after(:create) do |club|
      16.times do
        club.players << FactoryGirl.create(:player)
      end
    end

  end
end
