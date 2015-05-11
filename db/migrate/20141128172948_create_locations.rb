class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name, null: false, unique: true, index: true
      t.string :utm, null: false

      t.string :slug, null: false, index: true, unique: true

      t.timestamps null: false
    end
  end
end
