class ChangeGameRatingsToIntegers < ActiveRecord::Migration
  def up
    connection.execute(%q{
      alter table games
      alter column winner_rating
      type integer using cast(winner_rating as integer)
    })

    connection.execute(%q{
      alter table games
      alter column loser_rating
      type integer using cast(loser_rating as integer)
    })
  end

  def down
    change_column :games, :winner_rating, :string
    change_column :games, :loser_rating, :string
  end
end
