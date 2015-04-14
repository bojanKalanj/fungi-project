class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title, null: false, unique: true
      t.string :slug

      t.timestamps null: false
    end
  end
end
