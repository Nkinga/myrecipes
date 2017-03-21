require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "ken", email: "ken@example.com", password: "password", password_confirmation: "password")
  end
  
  test "reject invalid chef edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template "chefs/edit"
    patch chef_path, params: { chef: { chefname: " ", email: "ken@example.com"} }
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
   end
 
   test "accept valid chef edit" do
     sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template "chefs/edit"
    patch chef_path, params: { chef: { chefname: "ken1", email: "ken1@example.com"} }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "ken1", @chef.chefname
    assert_match "ken1@example.com", @chef.email
   end
 
end
