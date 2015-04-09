class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :name, null: false, unique: true
      t.string :slug_2, null: false, unique: true
      t.string :slug_3, null: false, unique: true
      t.boolean :default

      t.timestamps null: false
    end
  end
end
