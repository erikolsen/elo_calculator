require 'rails_helper'

describe Game do
  it { should belong_to(:winner).class_name('Player') }
  it { should belong_to(:loser).class_name('Player') }

  it { should validate_presence_of(:winner_id) }
  it { should validate_presence_of(:loser_id) }
  it { should validate_presence_of(:winner_rating) }
  it { should validate_presence_of(:loser_rating) }
end
