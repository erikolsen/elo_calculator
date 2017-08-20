class CreatePlayers < ActiveRecord::Migration[4.2]
  def change
    create_table :players do |t|
      t.string :name
      t.integer :rating

      t.timestamps
    end
  end
end
