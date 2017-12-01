class AddSquarePicToSpecies < ActiveRecord::Migration
  def change
    add_column :species, :square_pic, :string
    add_column :species, :square_pic_reference, :string
  end
end
