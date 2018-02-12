require 'rails_helper'

describe 'creating a new tournament' do
  let!(:club) { FactoryGirl.create :club, member_count: 5 }
  let(:players) { club.players.sort_by(&:rating).reverse }
  let(:player_1) { players[0] }
  let(:player_2) { players[1] }
  let(:player_3) { players[2] }

  let(:player_4) { players[3] }
  let(:new_player) { players[4] }

  context 'creating and playing the tournament' do
    let(:tournament_name) { 'Some Tournament' }
    let(:type) { %w(RoundRobin SingleElimination).sample }
    let(:series_max) { Tournament::SERIES_MAXES.sample }
    before do
      player_1.update_columns(:rating => 1600, name: 'Gamma')
      player_2.update_columns(:rating => 2000, name: 'Alpha')
      player_3.update_columns(:rating => 1700, name: 'Beta')
      player_4.update_columns(:rating => 1900, name: 'Unwanted Player')

      new_player.update_columns(rating: 1500, name: 'Z New Player')
    end

    it 'creates new tournament' do
      visit root_path

      within '.top-bar' do
        click_link 'Tournaments'
      end

      click_link 'Setup Tournament'
      expect(page).to have_content('Setup a New Tournament')
      fill_in 'Name', with: tournament_name
      find(:css, "#label_tournament_series_max_#{series_max}").click
      find(:css, "#label_#{type}").click
      find(:css, "#label_players_0").click
      find(:css, "#label_players_1").click
      find(:css, "#label_players_2").click
      find(:css, "#label_players_3").click
      click_button 'Continue to Registraion Page'

      # Registration Page
      expect(page).to have_content('Start Tournament')
      expect(page).to have_content(tournament_name)
      expect(page).to have_content(type.titleize)
      expect(page).to have_content("Matches will be Best of #{series_max}")

      # Add Player
      select new_player.name, from: 'tournament[players]'
      click_button 'Add Player'

      within '.seedTable' do
        expect(page).to have_content new_player.name
      end

      # Remove Player
      within '.seed_row_2' do
        expect(page).to have_content 'Unwanted Player'
        click_link 'Withdraw'
      end

      within '.seed_row_2' do
        expect(page).to have_content 'Beta'
      end
    end
  end
end
