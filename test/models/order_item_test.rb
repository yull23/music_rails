require "test_helper"

class OrderItemTest < ActiveSupport::TestCase
  def setup
    @user = User.create(
      username: "yull23",
      password: "password123",
      email: "yull_30@example.com",
      first_name: "yull",
      last_name: "timoteo"
    )
    @artist = Artist.create(name: "Artist")
    @order = Order.create(order_date: "2005-01-01", total: 50, user_id: @user.id)
    @album = Album.create(
      name: "Example Album",
      price: 10,
      duration: 120,
      artist_id: @artist.id
    )
    @order_item_test = OrderItem.create(quantity: 50, order_id: @order.id, album_id: @album.id)

    # print @order.save, @album.save, @order_item_test.save
    # puts @order_item_test.save
  end

  test "Validations for quantity" do
    # skip
    order_item = OrderItem.new(order_id: @order.id, album_id: @album.id)
    assert_not order_item.valid?, "It should not be saved, without the number of albums"
    order_item = OrderItem.new(order_id: @order.id, album_id: @album.id, quantity: 0)
    assert_not order_item.valid?, "Should not be saved with a number of albums equal to zero"
    order_item = OrderItem.new(order_id: @order.id, album_id: @album.id, quantity: -10)
    assert_not order_item.valid?, "It should not store a negative value for quantity"
    order_item = OrderItem.new(order_id: @order.id, album_id: @album.id, quantity: 5.56)
    assert_not order_item.valid?, "Should not accept values ​​other than an integer"
    order_item = OrderItem.new(order_id: @order.id, album_id: @album.id, quantity: 50)
    assert order_item.valid?, "It should save correctly with the positive and integer amount"
  end

  test "Validation for relationship belong_to" do
    assert_equal @order_item_test.album.id, @album.id,
                 "The album it belongs to must be the one that was declared"
    assert_equal @order_item_test.order.id, @order.id,
                 "The order it belongs to must be the one that was declared"
  end

  test "Verification of the calculation of the subtotal" do
    assert_equal @order_item_test.sub_total, @album.price * @order_item_test.quantity, ""
  end
end
