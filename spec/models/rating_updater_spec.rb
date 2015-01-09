require 'spec_helper'

RSpec.describe RatingUpdater do 
  let(:rating_updater) { RatingUpdater.new(winner_rating, 
                                           loser_rating) }
  let(:winner_rating) { 1000 }
  let(:loser_rating) { 1000 }

  it "calculates correct ratings when ratings are equal" do 
    expect(rating_updater.change_in_rating).to eq 25
  end

  context "it calculates correctly when the winner has a lower unbalanced rating" do 
    let(:winner_rating) { 900 }
    let(:loser_rating) { 1025 }
    let(:rating_updater) { RatingUpdater.new(winner_rating, 
                                             loser_rating) }
    it "does the thing" do 
      expect(rating_updater.change_in_rating).to eq 34
    end
  end
  
  context "it calculates correctly when the winner has a higher rating" do 
    let(:winner_rating) { 1025 }
    let(:loser_rating) { 975 }
    let(:rating_updater) { RatingUpdater.new(winner_rating, 
                                             loser_rating) }
    it "does the thing" do 
      expect(rating_updater.change_in_rating).to eq 22
    end
  end

  context "it calculates correctly when the winner has a lower rating" do 
    let(:winer_rating) { 975 }
    let(:loser_rating) { 1025 }
    let(:rating_updater) { RatingUpdater.new(winner_rating, 
                                             loser_rating) }
    it "does the thing" do 
      expect(rating_updater.change_in_rating).to eq 27
    end
  end



end

