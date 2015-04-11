class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.string :title, null: false
      t.string :authors
      t.string :isbn, unique: true
      t.string :url, unique: true
      t.string :uuid, index: true, unique: true
      t.string :slug, null: false, index: true, unique: true

      t.timestamps null: false
    end
  end
end
