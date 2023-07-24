# README

## Considerations

The scenario presented assumes that the project receives existing data from the sale of a record label.
For this, it is assumed or initialized, with the following considerations:

1. Artists and users are created first, assuming that their data is correct.
1. As a result of these, the albums are created, with the established date, and then each song to which it belongs is included one by one. (It is assumed that the entry is uniform, since at the end, the duration table of said album is added # It is done in the following way to avoid resorting to the callback).
1. The record of the purchase or order, for this the object is created, and then the data of each item of the order begins to be loaded
1. Finally, the user data and date where the purchase is made are loaded. (It must be verified that this date is greater than the date of the artist's birth, the date of the creation of albums, and to make sure that it is not from the future, it must be less than the date of today).

For better understanding, the following logic is proposed:

```
create artist
create user
create album
  duration=0 # album duration
  while value=true
    create song, album_id
    duration+=song.duration
    value = false if end
  add duration
create order
  total=0
  while value_1=true
    create order_item, album_id, user_id
      sub_total=0
      while value_2=true
        add album.id
        add album.price as price
        add quantity
        sub_total+=price*quantity
        value_2 = false if end
      add sub_total
    value_1 = false if end
  add total
  add user
  add dates
```

## Model Creation

1.  ERD (Entity relationship diagram).

    ![ERD](ERD.jpg)

    The corresponding relationships between the models are shown below:

    | Model       | Relation   | Model       |
    | :---------- | :--------- | :---------- |
    | artists     | has_many   | albums      |
    | albums      | belongs_to | artists     |
    | albums      | has_many   | songs       |
    | songs       | belongs_to | albums      |
    | albums      | has_many   | order_items |
    | order_items | belongs_to | albums      |
    | orders      | has_many   | order_items |
    | order_items | belongs_to | orders      |
    | users       | has_many   | orders      |
    | orders      | belongs_to | users       |

    They are summarized for each model in:

    |    Model    |   belong_to    |      has_many      |
    | :---------: | :------------: | :----------------: |
    |   albums    |    artists     | songs, order_items |
    |   artist    |       -        |       albums       |
    |    songs    |     albums     |         -          |
    | order_items | albums, orders |         -          |
    |   orders    |     users      |    order_items     |
    |    users    |       -        |       orders       |

1.  Creating models from the terminal input:

    ```
    rails generate model Artist name nationality birth_date:date death_date:date
    rails generate model User username email password first_name last_name flag:boolean
    rails generate model Album name price:integer artist:references
    rails generate model Song name duration:integer album:references
    rails generate model Order total:integer order_date:date user:references
    rails generate model OrderItem quantity:integer sub_total:integer album:references order:references
    ```

1.  Creation of the requested migrations:

    ```
     rails generate migration AddBiographyToArtists
     rails generate migration AddDurationToAlbums
     rails generate migration AddIndexToUsers
     rails generate migration ChangeDataTypeForBiographyInArtists
    ```

    The following code must be included, for the corresponding migrations

    ```
      def change
       add_colunm :artists, :biography, :string
      end
      def change
       add_column  :albums, :duration, :integer
      end
      def change
       add_index :users, :username
       add_index :users, :email
      end
      def up
       change_column :artists, :biography, :text
      end
      def down
       change_column :artists, :biography, :string
      end
    ```

1.  Edition of the validation for the database.
    Following these, the validation for the model is performed.

    | Model     | Null False          |
    | --------- | ------------------- |
    | Album     | name, price         |
    | Song      | name, duration      |
    | Artist    | name                |
    | User      | name, password      |
    | OrderItem | sub_total, quantity |
    | Orders    | total, date         |

    _La columna **email**, no fue colocada con null:false, debido a problemas con el test._

## Validations in the Models.

1. Artist Model Validation:

   - The date of birth (birth_date) cannot be in the future.

   - If the death date (death_date) is stored, two conditions must be met:

     - The date of birth (birth_date) must exist.
     - The death date (death_date) must be after the birth date (birth_date).

   The following validations are performed:

   ```
   class Artist < ApplicationRecord
     validates :name, uniqueness: true, presence: true
     validate :check_birth_date_presence
     validate :death_date_valid

     def check_birth_date_presence
       return unless death_date.present? && birth_date.blank?

       errors.add(:birth_date, "Must be present if death_date is provided")
     end

     def death_date_valid
       return unless birth_date.present? && death_date.present? && birth_date > death_date

       errors.add(:death_date, "must be greater than birth_date")
     end
   end
   ```

   The following test corresponds:

   ```
   require "test_helper"

   class ArtistTest < ActiveSupport::TestCase
     test "should not save artist without name" do
       artist = Artist.new
       assert_not artist.save, "Saved the artist without a name"
     end
     test "should save artist with valid name" do
       artist = Artist.new(name: "Joaquin")
       assert artist.save, "Could not save the artist with a valid name"
     end
     test "should not save artist with duplicate name" do
       artist_1 = Artist.create(name: "John Doe")
       artist_2 = Artist.new(name: "John Doe")
       assert_not artist_2.save, "Saved the artist with a duplicate name"
     end
     test "should require birth_date if death_date is provided" do
       artist = Artist.new(name: "Juan", death_date: "1998-01-01")
       assert_not artist.save, "Saved the artist with a death_date but no birth_date"
     end
     test "should save artist with valid birth_date and death_date" do
       artist = Artist.new(name: "Jane Doe", birth_date: Date.new(1990, 1, 1),
                           death_date: Date.new(2023, 1, 1))
       assert artist.save, "Could not save the artist with valid birth_date and death_date"
     end
     test "should not save artist with death_date earlier than birth_date" do
       artist = Artist.new(name: "Jane Doe", birth_date: Date.new(1990, 1, 1),
                           death_date: Date.new(1980, 1, 1))
       assert_not artist.save, "Saved the artist with death_date earlier than birth_date"
     end
     # Finish
   end
   ```

1. Artist Model Validation

   - Email must be in a valid email format.
   - The username is required and cannot be blank.
   - Password must be at least 6 characters long and must include at least one number.
   - By default, a client is active at the time of creation.
   - Both the username and the email must be unique in the database.

   The following validations are performed:
