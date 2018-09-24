class AddAvatarPicToUser < ActiveRecord::Migration
  def change
    add_column :users, :avatar_pic, :text
  end
end
