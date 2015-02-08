When(/^I click Add Club$/) do
    click_link 'Add Club'
end

Then(/^I am on the new club page$/) do
  expect(page.current_path).to eq new_club_path
end
