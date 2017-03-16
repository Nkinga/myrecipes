require 'test_helper'

class RecipesDeleteTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "muriel", email: "murie@example.com", password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name: "pown", description: "grated cassava in milk seasoned with spices and baked for 1 hr", chef: @chef)
  end 
  
  test "succesfully delete a recipe" do
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_select 'a[href=?]', recipe_path(@recipe), text: "delete this recipe"
    assert_difference "Recipe.count", -1 do
      delete recipe_path(@recipe)
    end
    assert_redirected_to recipes_path
    assert_not flash.empty?
  end
  
  
end
