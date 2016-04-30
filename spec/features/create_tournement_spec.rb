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



      #expect(last_game.winner_id).to eq(player1.id)
      #expect(last_game.loser_id).to eq(player2.id)

      #expect(last_game.winner_rating).to eq(starting_rating)
      #expect(last_game.loser_rating).to eq(starting_rating)
    end
  end
end
