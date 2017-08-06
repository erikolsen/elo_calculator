class AddTypeToTournament < ActiveRecord::Migration[5.1]
  def up
    add_column :tournaments, :tournament_type, :string
  end

  def down
    remove_column :tournaments, :tournament_type
  end
end
