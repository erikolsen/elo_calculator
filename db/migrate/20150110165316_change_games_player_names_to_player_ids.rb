class ChangeGamesPlayerNamesToPlayerIds < ActiveRecord::Migration
  def up
    add_column :games, :winner_id, :integer
    add_column :games, :loser_id, :integer

    Game.all.each do |game|
      game.winner_id = Player.find_by_name(game.winner_name).id
      game.loser_id = Player.find_by_name(game.loser_name).id

      game.save
    end

    remove_column :games, :winner_name
    remove_column :games, :loser_name

    add_index :games, :winner_id
    add_index :games, :loser_id
  end

  def down
    add_column :games, :winner_name, :string
    add_column :games, :loser_name, :string

    Game.all.each do |game|
      game.winner_name = Player.find(game.winner_id).name
      game.loser_name = Player.find(game.loser_id).name

      game.save
    end

    remove_column :games, :winner_id
    remove_column :games, :loser_id

    remove_index :games, :winner_id
    remove_index :games, :loser_id
  end
end
