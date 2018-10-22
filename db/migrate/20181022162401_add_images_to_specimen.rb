class AddImagesToSpecimen < ActiveRecord::Migration
  def change
    add_column :specimen, :images, :json
  end
end
