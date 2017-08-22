require 'rails_helper'

RSpec.describe SingleEliminationPresenter do
  describe '.present tournament_matchups' do
    let(:tournament_matchups) { (1..15).to_a }

    it 'breaks up the matchups into rounds' do
      expect(SingleEliminationPresenter.present(tournament_matchups)).to eq [ [1, 2, 3, 4, 5, 6, 7, 8],
                                                                              [9, 10, 11, 12],
                                                                              [13, 14],
                                                                              [15] ]
    end
  end
end
