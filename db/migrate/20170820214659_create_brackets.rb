class CreateBrackets < ActiveRecord::Migration[5.1]
  def change
    create_table :brackets do |t|
      t.belongs_to :tournament, index: true, foreign_key: true
      t.belongs_to :matchup, index: true, foreign_key: true
      t.boolean :bye, default: false
      t.string  :bracket_type, index: true
      t.integer :winner_child
      t.integer :loser_child
      t.integer :tournament_sequence, index: true
      t.integer :winner_id

      t.timestamps
    end
  end
end
