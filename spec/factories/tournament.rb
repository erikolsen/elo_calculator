FactoryGirl.define do
  factory :tournament do
    sequence(:name) { |n| "Tournament#{n}" }
    end_date   1.month.from_now
    created_at Date.current
    updated_at Date.current
    series_max 5
    type Tournament::TYPES.sample
  end

  factory :single_elimination, parent: :tournament, class: 'SingleElimination' do
    type 'SingleElimination'
  end

  factory :round_robin, parent: :tournament, class: 'RoundRobin' do
    type 'RoundRobin'
  end
end
