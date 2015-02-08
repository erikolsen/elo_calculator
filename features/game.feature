Feature: The Game Path
  In order to track my ratings
  As a player
  I want to play a game

  Background:
    Given I have some players 

    Scenario: Getting to new game page
      Given I visit the game index page
      When I click Add Game
      Then I am on the new game page

    Scenario: Creating a new game
      Given I visit the new game page
      When I enter a winner and a loser
      Then I am on the page for that game
