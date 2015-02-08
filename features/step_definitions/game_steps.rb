Given(/^I visit the game index page$/) do
  visit games_path
end

Given(/^I have some players$/) do
  Player.create! name: 'winner', rating: 1000
  Player.create! name: 'loser', rating: 1000
end

Given(/^I visit the new game page$/) do
  visit new_game_path
end

When(/^I click Add Game$/) do
  click_link 'Add Game'
end

Then(/^I am on the new game page$/) do
  expect(page.current_path).to eq new_game_path 
end

When(/^I enter a winner and a loser$/) do
      select Player.first.name, from: :game_winner_id
      select Player.last.name, from: :game_loser_id
      click_button 'Update Ratings'
end

Then(/^I am on the page for that game$/) do
  @game = Game.last
  visit "/games/#{@game.id}"
end
