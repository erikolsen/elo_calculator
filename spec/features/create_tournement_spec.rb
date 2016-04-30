require 'rails_helper'

describe 'creating a new tournament' do
  context 'setup tournament' do
    let(:tournament_name) { 'Some Tournament' }
    it 'creates new game' do
      visit root_path

      click_link 'Tournaments'
      click_link 'Setup Tournament'
      expect(page).to have_content('Setup a New Tournament')
      fill_in 'Name', with: tournament_name
      click_button 'Create Tournament'
      expect(find('h3')).to have_content(tournament_name)
    end
  end

  context 'joining a tournament' do
    let(:tournament_name) { 'Some Name' }
    let!(:new_tournament) { Tournament.create name: tournament_name }
    let(:player_1) { Player.create(name: 'Player 1') }
    let(:player_2) { Player.create(name: 'Player 2') }

    it 'lets players join tournament' do
      visit tournament_path(new_tournament)
      expect(find('h3')).to have_content(tournament_name)
      expect(page).to have_content(player_1.name)
    end

  end
end
