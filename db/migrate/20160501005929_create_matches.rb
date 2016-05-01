class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|

      t.timestamps null: false
    end
  end
end
