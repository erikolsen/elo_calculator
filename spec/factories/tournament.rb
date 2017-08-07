FactoryGirl.define do
  factory :tournament do
    sequence(:name) { |n| "Tournament#{n}" }
    end_date   1.month.from_now
    created_at Date.current
    updated_at Date.current
    tournament_type Tournament::TYPES.sample
  end
end
