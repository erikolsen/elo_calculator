require 'rails_helper'

describe 'Single Elimination Tournament' do
  let!(:club) { FactoryGirl.create :club, member_count: 7 }

  context 'creating tournament' do
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
      find(:css, "#label_players_4").click
      find(:css, "#label_players_5").click
      find(:css, "#label_players_6").click
      fill_in 'tournament[end_date]', with: '9999-10-10'
      click_button 'Create Tournament'
      expect(page).to have_content(tournament_name)
      expect(page).to have_content(type.titleize)
    end
  end
end
