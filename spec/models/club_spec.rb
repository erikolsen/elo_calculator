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

require 'rails_helper'

RSpec.describe Club, :type => :model do
  describe '#save' do
    let(:name) { 'Some Name' }
    subject { described_class.create!(name: name) }

    it 'sets the slug' do
      expect(subject.slug).to eq 'some-name'
    end
  end

  describe '#players_by_rating' do
    let(:name) { 'Some Name' }
    let(:player1) { FactoryGirl.create :player, rating: 1000 }
    let(:player2) { FactoryGirl.create :player, rating: 2000 }
    let(:player3) { FactoryGirl.create :player, rating: 3000 }

    subject { described_class.create!(name: name) }

    before do
      [player1, player2, player3].shuffle.each do |player|
        subject.memberships.create player: player
      end
    end
    it 'orders players by highest rating first' do
      expect(subject.players_by_rating).to eq [player3, player2, player1]
    end
  end
end
