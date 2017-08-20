class CreateEntries < ActiveRecord::Migration[4.2]
  def change
    create_table :entries do |t|
      t.belongs_to :tournament, index: true
      t.belongs_to :player, index: true

      t.timestamps null: false
    end
  end
end
