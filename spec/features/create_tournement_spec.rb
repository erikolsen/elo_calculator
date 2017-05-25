require 'rails_helper'

describe 'creating a new tournament' do
  context 'setup tournament' do
    let(:tournament_name) { 'Some Tournament' }
    let!(:player1) { Player.create! name: 'player 1' }
    let!(:player2) { Player.create! name: 'player 2' }
    it 'creates new game' do
      visit root_path

      within '.hamburger-menu' do
        click_link 'Tournaments'
      end
      click_link 'Setup Tournament'
      expect(page).to have_content('Setup a New Tournament')
      fill_in 'Name', with: tournament_name
      fill_in 'End Date', with: '9999-10-10'
      find(:css, "#tournament_players_0").set true
      find(:css, "#tournament_players_1").set true
      click_button 'Create Tournament'
      expect(page).to have_content(tournament_name)
    end
  end
end
