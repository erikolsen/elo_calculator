class ChangePlayersToHaveDefaultRating < ActiveRecord::Migration[4.2]
  def change
    change_column :players, :rating, :integer, default: 0, null: false
  end
end
