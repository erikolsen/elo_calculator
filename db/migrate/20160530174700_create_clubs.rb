class CreateClubs < ActiveRecord::Migration[4.2]
  def change
    create_table :clubs do |t|
      t.string :name
      t.string :slug
      t.index :slug

      t.timestamps null: false
    end
  end
end
