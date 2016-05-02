require 'faker'

namespace :setup do
  NUM_OF_PLAYERS = 30
  PLAYER_RANGE = (1..NUM_OF_PLAYERS).to_a
  DEFAULT_RATING = 1000

  desc "Setup Player and Games"
    task :all => :environment do
      Rake::Task['setup:create_players'].execute
      Rake::Task['setup:create_games'].execute
  end

  desc "db:drop, db:create, db:migrate, setup"
    task :clean_slate => :environment do
      Rake::Task['db:drop'].execute
      Rake::Task['db:create'].execute
      Rake::Task['db:migrate'].execute
      Rake::Task['setup:all'].execute
  end

  desc "Create Players"
    task :create_players => :environment do
      PLAYER_RANGE.each do |num|
        Player.create(name: Faker::StarWars.character, rating: DEFAULT_RATING)
      end
  end

  desc "Create Games"
    task :create_games => :environment do
      100.times do
        winner_id = PLAYER_RANGE.sample
        loser_id = (PLAYER_RANGE-[winner_id]).sample
        GameCreator.new(winner_id, loser_id).save
      end
  end
end
