class AddSquarePicToSpecimens < ActiveRecord::Migration
  def change
    add_column :specimen, :square_pic, :string
    add_column :specimen, :square_pic_reference, :string
  end
end
