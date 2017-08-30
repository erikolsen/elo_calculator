class CreateBracketMatchups < ActiveRecord::Migration[5.1]
  def change
    create_table :bracket_matchups do |t|
      t.belongs_to :tournament, index: true, foreign_key: true
      t.belongs_to :matchup, index: true, foreign_key: true
      t.integer :primary
      t.integer :secondary
      t.integer :winner_child
      t.integer :loser_child
      t.integer :tournament_sequence
      t.integer :winner

      t.timestamps
    end
  end
end
