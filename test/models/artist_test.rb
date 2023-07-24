# test/models/artist_test.rb

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
