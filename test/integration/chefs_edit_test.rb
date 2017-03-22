require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "ken", email: "ken@example.com", password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "garvin", email: "garvin@example.com", password: "password", password_confirmation: "password")
    @admin_user = Chef.create!(chefname: "garvin1", email: "garvin1@example.com", password: "password",
                                          password_confirmation: "password", admin: true)
  end
  
  test "reject invalid chef edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template "chefs/edit"
    patch chef_path(@chef), params: { chef: { chefname: " ", email: "ken@example.com"} }
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
   end
 
   test "accept valid chef edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template "chefs/edit"
    patch chef_path(@chef), params: { chef: { chefname: "ken1", email: "ken1@example.com"} }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "ken1", @chef.chefname
    assert_match "ken1@example.com", @chef.email
   end
   
   test "accept edit attempt by admin user" do
    sign_in_as(@admin_user, "password")
    get edit_chef_path(@chef)
    assert_template "chefs/edit"
    patch chef_path(@chef), params: { chef: { chefname: "ken2", email: "ken2@example.com"} }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "ken2", @chef.chefname
    assert_match "ken2@example.com", @chef.email
   end
   
   test "redirect edit attempt by another non-admin user" do
    sign_in_as(@chef2, "password")
    updated_name = "joey"
    updated_email = "joey@example.com"
    patch chef_path(@chef), params: { chef: { chefname: updated_name, email: updated_email } }
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match "ken", @chef.chefname
    assert_match "ken@example.com", @chef.email
   end
 
end
