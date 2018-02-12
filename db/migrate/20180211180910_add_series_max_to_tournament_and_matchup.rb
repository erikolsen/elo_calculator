class AddSeriesMaxToTournamentAndMatchup < ActiveRecord::Migration[5.1]
  def up
    add_column :tournaments, :series_max, :integer
    add_column :matchups, :series_max, :integer
  end

  def down
    remove_column :tournaments, :series_max
    remove_column :matchups, :series_max
  end
end
