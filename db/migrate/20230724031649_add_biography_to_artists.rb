class AddBiographyToArtists < ActiveRecord::Migration[7.0]
  def change
    add_column :artists, :biography, :string
  end
end
