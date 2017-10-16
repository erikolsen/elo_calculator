if Rails.env == 'development'
  require 'faker'

  namespace :setup do
    NUM_OF_PLAYERS = 30
    NUM_OF_TOURNAMENTS = 2
    PLAYER_RANGE = (1..NUM_OF_PLAYERS).to_a
    TOURNAMENT_RANGE = (1..NUM_OF_TOURNAMENTS).to_a
    DEFAULT_RATING = 1000

    desc "Setup Player and Games"
      task :all => :environment do
        Rake::Task['setup:create_players'].execute
        Rake::Task['setup:create_games'].execute
        Rake::Task['setup:create_tournaments'].execute
        Rake::Task['setup:create_clubs'].execute
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
        puts "Creating Players"
        PLAYER_RANGE.each do |num|
          Player.create(name: Faker::StarWars.character, rating: DEFAULT_RATING)
        end
    end

    desc "Create Tournaments"
      task :create_tournaments => :environment do
        puts "Creating Tournaments"
        TOURNAMENT_RANGE.each_with_index do |num, idx|
          type = idx.even? ? 'RoundRobin' : 'SingleElimination'
          creator = TournamentCreator.new(name: "Tournament #{num}", end_date: 1.week.from_now, players: Player.pluck(:id).take(6), type: type)
          raise 'Failed to create tournament' unless creator.save
        end
    end

    desc "Create Games"
      task :create_games => :environment do
        puts "Creating Games"
        100.times do
          winner_id = Player.ids.sample
          loser_id = (Player.ids-[winner_id]).sample
          GameCreator.new(winner_id, loser_id).save
        end
    end

    desc "Create Clubs"
      task :create_clubs => :environment do
        puts "Creating Clubs"
        3.times do
          club = Club.create name: Faker::StarWars.planet
          club.players << Player.all.sample(8)
        end
    end
  end
end
