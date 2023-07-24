class AddIndexToUsers < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :username
    add_index :users, :email
  end
end
