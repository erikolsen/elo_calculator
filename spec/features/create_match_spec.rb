require 'rails_helper'

describe "creating a new match" do
  let!(:player1) { Player.create! name: 'player 1', rating: 1000 }
  let!(:player2) { Player.create! name: 'player 2', rating: 1000 }
  let!(:game1) { Game.create! winner_id: player1.id,
                              loser_id: player2.id,
                              winner_rating: 1000,
                              loser_rating: 1000 }

  describe "from new game page" do
    context "entering best of five" do
      before do
        visit new_game_path
        click_on 'Best of Five'
        find(:css, "#label_games_1_#{player1.id}").click
        find(:css, "#label_games_2_#{player1.id}").click
        find(:css, "#label_games_3_#{player1.id}").click
        find(:css, "input[type='submit']").click
      end

      it "updates the ratings" do
        expect(page).to have_content "#{player1.name} won!"
        expect(page).to have_content "#{player1.name}'s new rating is 1066"
        expect(page).to have_content "#{player2.name}'s new rating is 934"
      end
    end
  end

  describe "using rematch links" do
    context "entering best of five" do
      before do
        visit player_path(player1)
        click_on "#{player1.name} vs. #{player2.name}"
        find(:css, "#label_games_1_#{player2.id}").click
        find(:css, "#label_games_2_#{player2.id}").click
        find(:css, "#label_games_3_#{player2.id}").click
        find(:css, "input[type='submit']").click
      end

      it "updates the ratings" do
        expect(page).to have_content "#{player2.name} won!"
        expect(page).to have_content "#{player2.name}'s new rating is 1066"
        expect(page).to have_content "#{player1.name}'s new rating is 934"
      end
    end
  end
end
