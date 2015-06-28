require 'rails_helper'

describe 'undoing a game' do
  let!(:winner) { Player.create! name: 'winner', rating: 1000 }
  let!(:loser) { Player.create! name: 'loser', rating: 1000 }
  it 'lets you undo a game if it was incorrectly entered' do
    visit new_game_path
    select winner.name, match: :first, from: :game_winner_id
    select loser.name, match: :first, from: :game_loser_id

    click_button 'Update Ratings'

    winner.reload
    loser.reload

    expect(page).to have_content('Game created')
    expect(find('h3')).to have_content('Game Summary')

    visit new_game_path
    select winner.name, match: :first, from: :game_winner_id
    select loser.name, match: :first, from: :game_loser_id
    click_button 'Update Ratings'

    winner.reload
    loser.reload
    expect(winner.rating).to eq 1047
    expect(loser.rating).to eq 953
    
    click_link 'Undo'
    expect(page.current_path).to eq "/games/new"

    winner.reload
    loser.reload
    expect(winner.rating).to be 1025
    expect(loser.rating).to be 975

    
    
  end
end
