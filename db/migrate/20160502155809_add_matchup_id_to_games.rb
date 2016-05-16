class AddMatchupIdToGames < ActiveRecord::Migration
  def up
    add_column :games, :matchup_id, :integer
    add_index :games, :matchup_id
  end

  def down
    remove_column :games, :matchup_id
    remove_index :games, :matchup_id
  end
end
