class AddIndexesToPlayers < ActiveRecord::Migration
  def change
    add_index :players, :name
    add_index :players, :rating
  end
end
