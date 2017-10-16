class CreateTournament < ActiveRecord::Migration[4.2]
  def change
    create_table :tournaments do |t|
      t.string :name
      t.timestamps
    end
  end
end
