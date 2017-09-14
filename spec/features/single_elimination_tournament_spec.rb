require 'rails_helper'

describe 'Single Elimination Tournament' do
  let!(:club) { FactoryGirl.create :club, member_count: 4 }
  let(:players) { club.players.sort_by(&:rating).reverse }
  let(:player_1) { players[0] }
  let(:player_2) { players[1] }
  let(:player_3) { players[2] }
  let(:player_4) { players[3] }

  context 'creating and playing the tournament' do
    let(:tournament_name) { 'Some Tournament' }
    let(:type) { 'single_elimination' }
    it 'creates new tournament' do
      visit root_path

      within '.top-bar' do
        click_link 'Tournaments'
      end

      click_link 'Setup Tournament'
      expect(page).to have_content('Setup a New Tournament')
      fill_in 'Name', with: tournament_name
      find(:css, "#label_#{type}").click
      find(:css, "#label_players_0").click
      find(:css, "#label_players_1").click
      find(:css, "#label_players_2").click
      find(:css, "#label_players_3").click
      fill_in 'tournament[end_date]', with: '9999-10-10'
      click_button 'Create Tournament'
      expect(page).to have_content(tournament_name)
      expect(page).to have_content(type.titleize)

      click_link("#{player_1.name} vs. #{player_4.name}")
      find(:css, "#label_games_1_#{player_1.id}").click
      find(:css, "#label_games_2_#{player_1.id}").click
      find(:css, "#label_games_3_#{player_1.id}").click
      find(:css, "input[type='submit']").click
      click_link 'Back to Tournament'

      click_link("#{player_2.name} vs. #{player_3.name}")
      find(:css, "#label_games_1_#{player_3.id}").click
      find(:css, "#label_games_2_#{player_3.id}").click
      find(:css, "#label_games_3_#{player_3.id}").click
      find(:css, "input[type='submit']").click
      click_link 'Back to Tournament'

      click_link("#{player_1.name} vs. #{player_3.name}")
      find(:css, "#label_games_1_#{player_3.id}").click
      find(:css, "#label_games_2_#{player_3.id}").click
      find(:css, "#label_games_3_#{player_3.id}").click
      find(:css, "input[type='submit']").click
      click_link 'Back to Tournament'
      winner = find(:css, '.winner').text
      # losers
      click_link("#{player_4.name} vs. #{player_2.name}")
      find(:css, "#label_games_1_#{player_4.id}").click
      find(:css, "#label_games_2_#{player_4.id}").click
      find(:css, "#label_games_3_#{player_4.id}").click
      find(:css, "input[type='submit']").click
      click_link 'Back to Tournament'
      expect(winner).to eql player_3.name
    end
  end
end
