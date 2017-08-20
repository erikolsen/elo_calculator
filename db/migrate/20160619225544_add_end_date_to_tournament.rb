class AddEndDateToTournament < ActiveRecord::Migration[4.2]
  def up
    add_column :tournaments, :end_date, :datetime
  end

  def down
    remove_column :tournaments, :end_date
  end
end
