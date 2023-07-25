require "test_helper"

class SongTest < ActiveSupport::TestCase
  def setup
    @artist = Artist.create(name: "Name")
    @album = Album.create(
      name: "Album",
      duration: 10,
      price: 10,
      artist_id: Artist.find_by(name: "Name").id
    )
  end
  test "Validations for Name" do
    song = Song.new(duration: 10, album_id: @album.id)
    assert_not song.valid?, "Shouldn't save Song with empty name"
    song_2 = Song.new(name: "", duration: 10, album_id: @album.id)
    assert_not song_2.valid?, "Shouldn't save Song with empty name"
    song_3 = Song.new(name: "Song", duration: 10, album_id: @album.id)
    assert song_3.valid?, "Shouldn't save Song with empty name"
  end

  test "Validations for duration" do
    song = Song.new(name: "Song", album_id: @album.id)
    assert_not song.valid?, "Shouldn't save without duration"
    song_2 = Song.new(name: "Song", duration: 0, album_id: @album.id)
    assert_not song_2.valid?, "Should not save with duration equal to zero"
    song_3 = Song.new(name: "Song", duration: -150, album_id: @album.id)
    assert_not song_3.valid?, "Shouldn't save with negative duration"
    song_4 = Song.new(name: "Song", duration: 50, album_id: @album.id)
    assert song_4.valid?, "Should save if duration is correct"
  end

  test "Validations for the belong_to relationship" do
    song = Song.create(name: "Song_1", duration: 50, album_id: @album.id)
    assert_equal song.album.id, @album.id,
                 "It should belong to the album with which it was declared"
  end
end
