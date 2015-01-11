class ChangePlayersToHaveDefaultRating < ActiveRecord::Migration
  def change
    change_column :players, :rating, :integer, default: 0, null: false
  end
end
