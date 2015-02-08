Feature: The Root Path
  In order to track my ratings
  As a player
  I want to play a match

  Scenario: Getting to new Player page
    Given I visit the root page
    When I click New Player
    Then I am on the new player page

  Scenario: Creating a new player
    Given I visit the new player page
    When I enter a name and submit
    Then I have a player with a rating of 1000
