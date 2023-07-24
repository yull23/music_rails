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
