class AddSquarePicToSpecies < ActiveRecord::Migration
  def change
    add_column :species, :square_pic, :string
  end
end
