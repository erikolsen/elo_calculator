class CreateMatchupsGames < ActiveRecord::Migration
  def change
    create_table :matchups_games do |t|
      t.belongs_to :matchup, index: true
      t.belongs_to :game, index: true
    end
  end
end
