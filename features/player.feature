Feature: The Player Path
  In order to track my ratings
  As a player
  I want to add my name to the pool

  Scenario: Getting to new Player page
    Given I visit the root page
    When I click Add Player
    Then I am on the new player page

  Scenario: Creating a new player
    Given I visit the new player page
    When I enter a name and submit
    Then I have a player with a rating of 1000
