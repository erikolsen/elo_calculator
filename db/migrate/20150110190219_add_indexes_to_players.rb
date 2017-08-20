class AddIndexesToPlayers < ActiveRecord::Migration[4.2]
  def change
    add_index :players, :name
    add_index :players, :rating
  end
end
