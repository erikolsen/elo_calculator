require 'rails_helper'

describe 'Player Profile' do
  let!(:player1) { Player.create! name: 'Player 1' }
  let!(:player2) { Player.create! name: 'Player 2' }
  let!(:player3) { Player.create! name: 'Player 3' }

  let!(:game1) { Game.create! winner_id: player1.id, loser_id: player2.id, winner_rating: 1000, loser_rating: 1000 }
  let!(:game2) { Game.create! winner_id: player2.id, loser_id: player1.id, winner_rating: 3000, loser_rating: 2000 }
  let!(:game3) { Game.create! winner_id: player3.id, loser_id: player2.id, winner_rating: 5000, loser_rating: 6000 }

  describe 'visiting player profile' do
    before do
      visit player_path(player1.id)
    end

    it 'shows player name and rating' do
      expect(page).to have_content(player1.name)
      expect(page).to have_content(player1.rating)
    end

    it 'shows players past games' do
      expect(page).to have_content("Games Played (2)")

      within "#game-#{game1.id}" do
        expect(find('.winner')).to have_content(player1.name)
        expect(find('.loser')).to have_content(player2.name)
      end

      within "#game-#{game2.id}" do
        expect(find('.winner')).to have_content(player2.name)
        expect(find('.loser')).to have_content(player1.name)
      end

      expect(page).to_not have_content(player3.name)
    end

    it 'lets you update your personal information' do
      expect(page).to have_link('Claim your account')
      click_link 'Claim your account'
      expect(page.current_path).to eq(new_player_account_path(player_id: player1.id))
    end
  end

end
