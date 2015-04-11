class CreateSpecimen < ActiveRecord::Migration
  def change
    create_table :specimen do |t|
      t.belongs_to :species, null: false, index: true, foreign_key: true
      t.belongs_to :location, null: false, index: true, foreign_key: true

      t.references :legator, null: false, index: true
      t.string :legator_text

      t.references :determinator, index: true
      t.string :determinator_text

      t.text :habitats
      t.text :substrates

      t.date :date, null: false
      t.text :quantity

      t.text :note

      t.boolean :approved

      t.string :uuid, index: true, unique: true
      t.string :slug, null: false, index: true, unique: true

      t.timestamps null: false
    end
  end
end
