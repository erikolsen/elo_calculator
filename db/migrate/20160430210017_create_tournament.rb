class CreateTournament < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.timestamps
    end
  end
end
