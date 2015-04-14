class CreateLocalizedPages < ActiveRecord::Migration
  def change
    create_table :localized_pages do |t|
      t.belongs_to :language, index: true, foreign_key: true
      t.belongs_to :page, index: true, foreign_key: true

      t.string :title, null: false
      t.text :content
      t.string :slug

      t.timestamps null: false
    end
  end
end
