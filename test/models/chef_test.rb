require "test_helper"

class ChefTest < ActiveSupport::TestCase
  
  def setup 
    @chef = Chef.new(chefname: "Vivian", email: "vivian@example.com",
                      password: "password", password_confirmation: "password")
  end
  
  test "chef should be valid" do
    assert @chef.valid?
  end 
  
  test "chefname should be present" do
    @chef.chefname = " "
    assert_not @chef.valid?
  end
  
  test "chefname should not be more than 30 characters" do
    @chef.chefname = "a" * 31
    assert_not @chef.valid?
  end
  
  test "email should be present" do
    @chef.email = " "
    assert_not @chef.valid?
  end
  
  test "email should not be more than 255 characters" do
    @chef.email = "a" * 245 + "@example.com"
    assert_not @chef.valid?
  end
  
  test "email should accept correct format" do
    valid_emails = %w[user@example.com KENJACHER@gmail.com kaj.fisrt@yahoo.ca james+bond@co.uk.org]
    valid_emails.each do |valids|
      @chef.email = valids
      assert @chef.valid?, "#{valids.inspect} should be valid"
    end
  end
  
  test "should reject invalid email addresses" do
    invalid_emails = %w[user@example kenjarcher@gmail,com kaj,first@yahoo. raj@bar+foo.com]
    invalid_emails.each do |invs|
      @chef.email = invs
      assert_not @chef.valid?, "#{invs.inspect} should be invalid"
    end
  end
  
  test "email should be unique and case insensitive" do
    duplicate_chef = @chef.dup
    duplicate_chef.email = @chef.email.upcase
    @chef.save
    assert_not duplicate_chef.valid?
  end
  
  test "email should be lowercase before hitting db" do
    mixed_email = "JoHn@Example.com"
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end
  
  test "password should be present" do
    @chef.password = @chef.password_confirmation = " "
    assert_not @chef.valid?
  end
  
  test "password should be atleast 5 characters" do
    @chef.password = @chef.password_confirmation = "x" * 4
    assert_not @chef.valid?
  end
  
  test "should delete associated recipes" do
    @chef.save
    @chef.recipes.create!(name: "test destroy", description: "test destroy function")
    assert_difference "Recipe.count", -1 do
      @chef.destroy
    end 
  end 
  
end