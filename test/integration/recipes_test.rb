require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "muriel", email: "murie@example.com")
    @recipe = Recipe.create(name: "pown", description: "grated cassava in milk seasoned with spices and baked for 1 hr", chef_id: @chef)
    @recipe2 = @chef.recipes.create(name: "fish broth", description: "well seasoned fish, sliced boiled in water with vegetables and dumplings")
  end
  
  test "should get recipes url" do
    get recipes_url
    assert_response :success
  end 
  
  test "should get recipes listing" do
    get recipes_path
    assert_template 'recipes/index'
    assert_match @recipe.name, response.body
    assert_match @recipe2.name, response.body
  end
end
