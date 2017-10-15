class AddTypeToTournament < ActiveRecord::Migration[5.1]
  def up
    add_column :tournaments, :type, :string
    add_column :tournaments, :start_date, :datetime
    add_column :tournaments, :club_id, :integer
    add_index :tournaments, :type
    add_index :tournaments, :club_id
  end

  def down
    remove_column :tournaments, :type
    remove_column :tournaments, :start_date
    remove_column :tournaments, :club_id
    remove_index :tournaments, :type
    remove_index :tournaments, :club_id
  end
end
