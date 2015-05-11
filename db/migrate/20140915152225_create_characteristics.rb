class CreateCharacteristics < ActiveRecord::Migration
  def change
    create_table :characteristics do |t|
      t.belongs_to :reference, null: false, index: true, foreign_key: true
      t.belongs_to :species, null: false, index: true, foreign_key: true

      t.boolean :edible
      t.boolean :cultivated
      t.boolean :poisonous
      t.boolean :medicinal

      t.text :fruiting_body
      t.text :microscopy
      t.text :flesh
      t.text :chemistry
      t.text :note

      t.text :habitats
      t.text :substrates

      t.string :slug, null: false, index: true, unique: true

      t.timestamps null: false
    end
  end
end
