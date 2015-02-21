require 'rails_helper'

describe 'Player Profile' do
  let!(:player) { Player.create!(name: 'Olsen') }

  describe 'visiting player profile' do
    it 'allows players to see their profile' do
      visit root_path
      click_link player.name

      expect(page.current_path).to eq(player_path(player.id))
      expect(page).to have_content(player.name)
      expect(page).to have_content(player.rating)
    end
  end
end
