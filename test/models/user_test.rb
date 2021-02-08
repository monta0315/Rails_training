require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user=User.create(name:"Example",email:"user@example.com",
                      password:"foobar",password_confirmation:"foobar")
  end
  test "should ba vaild" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name=" "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email=" "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name='a'*51
    assert_not @user.valid?
  end

  test "email should be not too long" do
    @user.email = 'b'*256
    assert_not @user.valid?
  end

  test "email vaidation should accept valid address" do
    valid_address=%w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_address.each do|address|
      @user.email=address
      assert @user.valid?",#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid address" do
    invalid_address=%w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_address.each do |address|
      @user.email=address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email address should be unique" do
    duplicate_user=@user.dup
    duplicate_user.email=@user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExaMPle.CoM"
    @user.email=mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase,@user.reload.email
  end

  test "passeord should be present (nonblank)" do
    @user.password=@user.password_confirmation=" "*6
    assert_not @user.valid?
  end

  test "passeword should have a minimum length" do
    @user.password=@user.password_confirmation="a"*5
    assert_not @user.valid?
  end

end
