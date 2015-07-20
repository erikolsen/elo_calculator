[![Stories in Ready](https://badge.waffle.io/erikolsen/elo_calculator.png?label=ready&title=Ready)](https://waffle.io/erikolsen/elo_calculator)
[![Code Climate](https://codeclimate.com/github/erikolsen/elo_calculator/badges/gpa.svg)](https://codeclimate.com/github/erikolsen/elo_calculator)

#Record the Results of any two player game

(It works great for ping pong!)

To set your own app name use the enviroment variable ELO_APP_NAME

Applican is designed for easy deployment to heroku

Application allows you to do the following:

Create a player

Play a match

Enter the results

See your rating change

##What an Elo rating tells you
Two players with equal ratings should stand an equal change of winning
A player with a rating 100 points higher should win 64% of the time.
A player with a rating 200 points higher should win 76% of the time.

This application uses a K factor 50.  50 is the most points a player can win
or lose in a single game.  When the players have an equal rating the winner will gain 25 points and the loser will lose 25 points.  If a higher rated person beats a lower rated person they will gain fewer points then if they beat a higher rated person.  The lower rated person who loses to higher rated person will also lose fewer points then if they lose to a higher rated player.
