require 'rails_helper'

describe 'Round Robin Tournament' do
  let!(:club) { FactoryGirl.create :club, member_count: 4 }
  let(:players) { club.players.sort_by(&:rating).reverse }
  let(:player_1) { players[0] }
  let(:player_2) { players[1] }
  let(:player_3) { players[2] }
  let(:player_4) { players[3] }

  context 'creating and playing the tournament' do
    let(:tournament_name) { 'Some Tournament' }
    let(:type) { 'RoundRobin' }
    before do
      player_1.update_column(:rating, 1500)
      player_2.update_column(:rating, 1100)
      player_3.update_column(:rating, 2000)
      player_4.update_column(:rating, 1700)
    end

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

      # Registration Page
      expect(page).to have_content(tournament_name)
      expect(page).to have_content(type.titleize)

      #first  = find(:css, '#1st').text
      #second = find(:css, '#2nd').text
      #third = find(:css, '#3rd').text
      #fourth  = find(:css, '#4th').text

      #expect(first).to include player_6.name
      #expect(second).to include player_4.name
      #expect(third).to include player_1.name
      #expect(fourth).to include player_7.name

      #winner = find(:css, '.winner').text
      #expect(winner).to eql player_6.name

    end
  end
end
