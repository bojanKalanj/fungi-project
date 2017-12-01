class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.belongs_to :reference, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.belongs_to :species, foreign_key: true
      t.belongs_to :specimen

      t.string :image, null: false
      t.string :type, null: false
      t.boolean :approved, default: false
      t.string :source_url
      t.string :source_title
    end
  end
end
