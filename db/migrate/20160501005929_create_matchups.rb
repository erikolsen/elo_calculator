class CreateMatchups < ActiveRecord::Migration
  def change
    create_table :matchups do |t|
      t.integer :primary_id
      t.integer :secondary_id
      t.integer :winner_id
      t.belongs_to :tournament, index: true
      t.timestamps null: false
    end
  end
end
