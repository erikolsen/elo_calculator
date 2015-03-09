require 'rails_helper'

describe 'Claiming an account' do
  let!(:player) { Player.create! name: 'Player' }
  let(:email) { 'test@example.com' }
  let(:password) { 'password' }

  it 'should ask for email and password' do
    visit new_player_accounts_path(player_id: player.id)

    fill_in :account_email, with: email
    fill_in :account_password, with: password
    fill_in :account_password_confirmation, with: password

    click_button 'Claim Account'

    expect(page).to have_content('Your account has been claimed!')
    expect(player.email).to eq(email)
    expect(player.password_hash).to_not eq(nil)
  end
end
