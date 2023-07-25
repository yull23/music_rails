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
    assert_not order.valid?, "It should not be saved with the order_date field empty"
    order = Order.new(order_date: "yull", total: 20, user_id: @user.id)
    assert_not order.valid?, "It should not be saved, if it is not given a correct date format"
    order = Order.new(order_date: "2995-01-01", total: 20, user_id: @user.id)
    assert_not order.valid?, "Shouldn't save to a future date"
    order = Order.new(order_date: "1995-01-01", total: 20, user_id: @user.id)
    assert order.valid?, "It should save correctly with a valid date"
  end

  test "Validations for total" do
    # skip
    order = Order.new(order_date: "1995-01-01", user_id: @user.id)
    assert_not order.valid?, "It should not be saved without the total field."
    order = Order.new(order_date: "1995-01-01", total: 0, user_id: @user.id)
    assert_not order.valid?, "Should not be saved with a total equal to zero"
    order = Order.new(order_date: "1995-01-01", total: -10, user_id: @user.id)
    assert_not order.valid?, "Should not be saved with a negative total"
    order = Order.new(order_date: "1995-01-01", total: 10, user_id: @user.id)
    assert order.valid?, "It should save the order correctly"
  end

  test "Validations for the belong_to relationship" do
    # skip
    order = Order.create(order_date: "2005-01-01", total: 10, user_id: @user.id)
    assert_equal order.user.id, @user.id,
                 "It should belong to the user with which it was created"
  end
end
