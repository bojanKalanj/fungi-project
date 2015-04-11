class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.belongs_to :parent, class_name: Language, null: true

      t.string :name, null: false, unique: true
      t.string :title, null: false, unique: true
      t.string :locale, null: false, unique: true
      t.string :flag, null: false
      t.boolean :default

      t.string :slug, null: false

      t.timestamps null: false
    end

    add_index :languages, :slug, :unique => true
  end
end
