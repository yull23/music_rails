class CreateAlbums < ActiveRecord::Migration[7.0]
  def change
    create_table :albums do |t|
      t.string :name,null:false
      t.integer :price,null:false
      t.references :artist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
