class CreateBracketMatchups < ActiveRecord::Migration[5.1]
  def change
    create_table :bracket_matchups do |t|
      t.belongs_to :tournament, index: true, foreign_key: true
      t.belongs_to :matchup, index: true, foreign_key: true
      t.string  :primary
      t.string  :secondary
      t.integer :primary_parent
      t.integer :secondary_parent
      t.integer :tournament_sequence
      t.integer :winner

      t.timestamps
    end
  end
end
