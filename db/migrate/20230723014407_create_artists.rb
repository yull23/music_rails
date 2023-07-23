class CreateArtists < ActiveRecord::Migration[7.0]
  def change
    create_table :artists do |t|
      t.string :name, null: false
      t.string :nationality
      t.date :birth_date
      t.date :death_date
      t.timestamps
    end
  end
end
