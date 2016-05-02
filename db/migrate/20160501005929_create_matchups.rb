class CreateMatchups < ActiveRecord::Migration
  def change
    create_table :matchups do |t|
      t.integer :primary
      t.integer :secondary
      t.integer :winner
      t.belongs_to :tournament, index: true
      t.timestamps null: false
    end
  end
end
