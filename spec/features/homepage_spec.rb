require 'rails_helper'

describe 'homepage' do
  describe 'starting a club' do
    let(:club_name) { Faker::Team.name }

    it 'adds the club link to the homepage' do
      visit root_path
      click_link 'Join a Club'
      click_link 'Start a Club'
      fill_in :club_name, with: club_name
      click_button 'Add Club'

      expect(page).to have_content(club_name)
      expect(page).to have_content('Start a Club')
    end
  end

  describe 'has access to the all players page' do
    let!(:player1) { Player.create! name: 'player 1', rating: 500 }
    let!(:player2) { Player.create! name: 'player 2', rating: 600 }

    let!(:game1) { Game.create! winner_id: player1.id, loser_id: player2.id, winner_rating: 400, loser_rating: 500 }
    let!(:game2) { Game.create! winner_id: player2.id, loser_id: player1.id, winner_rating: 500, loser_rating: 400 }

    it 'shows player ratings' do
      visit root_path

      within "#player-#{player1.id}" do
        expect(find('.rank')).to have_content(2)
        expect(find('.name')).to have_content(player1.name)
        expect(find('.rating')).to have_content(player1.rating)
        expect(find('.won-lost')).to have_content("1 / 1")
      end

      within "#player-#{player2.id}" do
        expect(find('.rank')).to have_content(1)
        expect(find('.name')).to have_content(player2.name)
        expect(find('.rating')).to have_content(player2.rating)
        expect(find('.won-lost')).to have_content("1 / 1")
      end
    end
  end

  describe 'visiting player profile' do
    let!(:player) { Player.create!(name: 'Olsen') }

    describe 'visiting player profile' do
      it 'allows players to see their profile' do
        visit players_path
        click_link player.name
        expect(page.current_path).to eq(player_path(player.id))
      end
    end
  end
end
