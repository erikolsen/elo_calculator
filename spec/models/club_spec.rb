require 'rails_helper'

RSpec.describe Club, :type => :model do
  describe '#save' do
    let(:name) { 'Some Name' }
    subject { described_class.create!(name: name) }

    it 'sets the slug' do
      expect(subject.slug).to eq 'some-name'
    end
  end
end
