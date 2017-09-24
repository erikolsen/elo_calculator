class AddTypeToTournament < ActiveRecord::Migration[5.1]
  def up
    add_column :tournaments, :type, :string
    add_index :tournaments, :type
  end

  def down
    remove_column :tournaments, :type
    remove_index :tournaments, :type
  end
end
