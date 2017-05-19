class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.belongs_to :player, index: true, foreign_key: true
      t.belongs_to :club, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
