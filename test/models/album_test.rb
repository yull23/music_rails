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
