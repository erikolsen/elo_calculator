require 'rails_helper'

describe 'creating a new tournament' do
  describe 'round robin' do
    context 'setup tournament' do
      let(:tournament_name) { 'Some Tournament' }
      let(:type) { 'round_robin' }
      let!(:player1) { Player.create! name: 'player 1' }
      let!(:player2) { Player.create! name: 'player 2' }

      it 'creates new tournament' do
        visit root_path

        within '.icon-bar' do
          click_link 'Tournaments'
        end

        click_link 'Setup Tournament'
        expect(page).to have_content('Setup a New Tournament')
        fill_in 'Name', with: tournament_name
        fill_in 'tournament[end_date]', with: '9999-10-10'
        find(:css, "##{type}").set true
        find(:css, "#tournament_players_0").set true
        find(:css, "#tournament_players_1").set true
        click_button 'Create Tournament'
        expect(page).to have_content(tournament_name)
        expect(page).to have_content(type.titleize)
      end
    end
  end
end
