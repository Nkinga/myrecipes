require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "muriel", email: "murie@example.com")
    @recipe = Recipe.create(name: "pown", description: "grated cassava in milk seasoned with spices and baked for 1 hr", chef: @chef)
  end 
  
  test "reject invalid recipe update" do
    get edit_recipes_path(@recipe)
    assert_template "recipes/edit"
    patch recipes_path(@recipe), params: { recipe: {name: " ", description: " " } }
    assert_template "recipes/edit"
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test "successfully edit a recipe" do
    get edit_recipes_path(@recipe)
    assert_template "recipes/edit"
    updated_name = "updated recipe name"
    updated_description = "updated recipe description"
    patch recipes_path(@recipe), params: { recipe: {name: updated_name, description: updated_description } }
    assert_redirect_to @recipe # follow_redirect! - same as
    assert_not flash.empty?
    assert_match updated_name, @recipe.name
    assert_match updated_description, @recipe.description
  end
  
end