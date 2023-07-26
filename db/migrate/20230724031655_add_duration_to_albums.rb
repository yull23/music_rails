class AddDurationToAlbums < ActiveRecord::Migration[7.0]
  def change
    add_column :albums, :duration, :integer, default:0
  end
end
