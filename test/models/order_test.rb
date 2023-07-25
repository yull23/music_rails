require "test_helper"

class OrderTest < ActiveSupport::TestCase
  def setup
    @user = User.create(
      username: "yull23",
      password: "password123",
      email: "yull_30@example.com",
      first_name: "yull",
      last_name: "timoteo"
    )
  end

  test "Validations for order_date" do
    # skip
    order = Order.new(total: 20, user_id: @user.id)
    assert_not order.valid?, "No deberia guardarse sin un order_date"
    order = Order.new(order_date: "2026-258-25", total: 20, user_id: @user.id)
    assert_not order.valid?, "No deberia guardar un formato invalido"
    order = Order.new(order_date: "2005-11-11", total: 20, user_id: @user.id)
    assert order.valid?, "Debería poder guardar la fecha con un formato valido"
    order = Order.new(order_date: "1995-11-11", total: 20, user_id: @user.id)
    assert order.valid?, "Debería poder guardar la fecha con un formato valido"
  end

  test "Validations for duration" do
    skip
    order = Order.new(name: "order", album_id: @album.id)
    assert_not order.valid?, "Shouldn't save without duration"
    song_2 = Order.new(name: "order", duration: 0, album_id: @album.id)
    assert_not song_2.valid?, "Should not save with duration equal to zero"
    song_3 = Order.new(name: "order", duration: -150, album_id: @album.id)
    assert_not song_3.valid?, "Shouldn't save with negative duration"
    song_4 = Order.new(name: "order", duration: 50, album_id: @album.id)
    assert song_4.valid?, "Should save if duration is correct"
  end
end
