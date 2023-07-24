class ChangeDataTypeForBiographyInArtists < ActiveRecord::Migration[7.0]
  def up
    change_column :artists, :biography, :text
  end
  def down
    change_column :artists, :biography, :string
  end
end
