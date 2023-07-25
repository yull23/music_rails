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

1. User Model Validation

   - Email must be in a valid email format.
   - The username is required and cannot be blank.
   - Password must be at least 6 characters long and must include at least one number.
   - By default, a client is active at the time of creation.
   - Both the username and the email must be unique in the database.

   The following validations are performed:

   ```
   class User < ApplicationRecord
     has_many :orders
     validates :username, presence: true,
                         format: { with: /\A[A-Za-z0-9]+\z/, message: "must only contain letters and numbers" },
                         uniqueness: true
     validates :email, presence: true,
                     format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" },
                     uniqueness: true
     validates :password, length: { minimum: 6, message: "must be at least 6 characters long" },
                         format: { with: /\d/, message: "must include at least one number" }
     validates :first_name, presence: true
     validates :last_name, presence: true
     before_validation :default_flag_to_true

     def default_flag_to_true
       self.flag = true
     end
   end

   ```

   The following test corresponds:

   ```
   require "test_helper"

   class UserTest < ActiveSupport::TestCase
     def setup
       @user = User.new(
         username: "yull123",
         password: "password123",
         email: "yull@example.com",
         first_name: "yull",
         last_name: "Doe"
       )
       @user_1 = User.new(
         username: "yull123",
         password: "password123",
         email: "yull_30@example.com",
         first_name: "yull",
         last_name: "Doe"
       )
       @user_2 = User.new(
         username: "yull12345",
         password: "password123",
         email: "yull_30@example.com",
         first_name: "yull",
         last_name: "Doe"
       )
       @user_3 = User.new(
         username: "yull12345",
         password: "password123",
         email: "yull_30@exampl",
         first_name: "yull",
         last_name: "Doe"
       )
     end

     test "should be valid with all required attributes" do
       # skip
       assert @user.valid?, "User with all required attributes should be valid"
     end

     test "should not be valid without a username" do
       # skip
       @user.username = ""
       assert_not @user.valid?, "User without username should not be valid"
     end

     test "should only contain letters and numbers in the username" do
       # skip
       invalid_usernames = ["john_doe", "user@name", "user!name"]
       invalid_usernames.each do |username|
         @user.username = username
         assert_not @user.valid?, "Username should only contain letters and numbers"
       end
     end
     test "should have a unique username" do
       # skip
       @user.save
       assert_not @user_1.valid?, "User with duplicate username should not be valid"
     end
     test "should not save user with duplicate email" do
       # skip
       @user_1.save
       assert_not @user_2.valid?, "User with duplicate email should not be saved"
     end

     test "should not be valid without an email" do
       # skip
       @user_2.email = ""
       assert_not @user_2.valid?, "User without email should not be valid"
     end

     test "should have a valid email format" do
       # skip
       invalid_emails = ["johnexample", "johnexample.", "johnexample.com"]
       invalid_emails.each do |email|
         @user_2.email = email
         assert_not @user_2.valid?, "User should not be valid with invalid email: #{email}"
       end
     end

     test "should not be valid without a password" do
       # skip
       @user_2.password = ""
       assert_not @user_2.valid?, "User without password should not be valid"
     end

     test "should not be valid with a password less than 6 characters" do
       # skip
       @user_2.password = "pass1"
       assert_not @user_2.valid?, "User with password less than 6 characters should not be valid"
     end

     test "should not be valid with a password without a number" do
       # skip
       @user_2.password = "password"
       assert_not @user_2.valid?, "User with password without a number should not be valid"
     end

     test "should not be valid without a first_name" do
       # skip
       @user_2.first_name = ""
       assert_not @user_2.valid?, "User without first name should not be valid"
     end

     test "should not be valid without a last_name" do
       # skip
       @user_2.last_name = ""
       assert_not @user_2.valid?, "User without last name should not be valid"
     end

     test "should default flag to true before validation" do
       # skip
       @user_2.flag = nil
       @user_2.save
       assert_equal true, @user.flag
     end
   end
   ```

1. Album Model Validation

   - Cada álbum tiene un nombre.
   - Cada álbum tiene un precio almacenado en centavos.
   - Un álbum tiene muchas canciones.
   - Un álbum pertenece a un artista (solo a un artista).
   - Un álbum válido siempre tiene un nombre.
   - Un álbum válido siempre tiene un precio mayor que cero (en centavos).
   - Un álbum válido siempre tiene una duración mayor que cero.

   The following validations are performed:

   ```
   class Album < ApplicationRecord
     belongs_to :artist
     has_many :songs
     has_many :order_items
     validates :name, presence: true
     validates :price, presence: true, numericality: { greater_than: 0 }
     validates :duration, presence: true, numericality: { greater_than: 0 }
   end
   ```

   The following test corresponds:

   ```
   require "test_helper"

   class AlbumTest < ActiveSupport::TestCase
     def setup
       Artist.create(name: "Artist 1")
     end

     test "should be valid with all required attributes" do
       # skip
       album = Album.new(
         name: "Example Album",
         price: 9.99,
         duration: 120,
         artist_id: Artist.find_by(name: "Artist 1").id
       )
       assert album.valid?
     end

     test "should not be valid without a name" do
       # skip
       album = Album.new(
         price: 9.99,
         duration: 120,
         artist_id: Artist.find_by(name: "Artist 1").id
       )
       assert_not album.valid?
     end

     test "should not be valid without a price" do
       # skip
       album = Album.new(
         name: "Example Album",
         duration: 120,
         artist_id: Artist.find_by(name: "Artist 1").id
       )
       assert_not album.valid?
     end

     test "should not be valid without a duration" do
       # skip
       album = Album.new(
         name: "Example Album",
         price: 9.99,
         artist_id: Artist.find_by(name: "Artist 1").id
       )
       assert_not album.valid?
     end
   end
   ```
