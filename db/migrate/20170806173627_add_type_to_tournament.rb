class AddTypeToTournament < ActiveRecord::Migration[5.1]
  def up
    add_column :tournaments, :type, :string
  end

  def down
    remove_column :tournaments, :type
  end
end
