class AddSquarePicToSpecimens < ActiveRecord::Migration
  def change
    add_column :specimen, :square_pic, :string
  end
end
