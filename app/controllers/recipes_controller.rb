class RecipesController < ApplicationController
  before_action :set_recipe, only: [:edit, :show, :update, :destroy]
  
  def index
    @recipes = Recipe.paginate(page: params[:page], per_page: 5)
  end
  
  def show
    
  end
  
  def new
    @recipe = Recipe.new
  end
  
  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.chef = Chef.first
    
    if @recipe.save
      flash[:notice] = "Recipe was successfully created"
      redirect_to recipe_path(@recipe)
    else
      render 'new'
    end
  end  
  
  def edit
    
  end
  
  def update
    if @recipe.update(recipe_params)
      flash[:notice] = "Recipe was successfully updated"
      redirect_to recipe_path(@recipe)
    else
      render 'edit'
    end 
  end
  
  def destroy
    @recipe.destroy
      flash[:notice] = "Recipe was successfully deleted." 
      redirect_to recipes_path
  end
  
  private
    
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end
  
    def recipe_params
      params.require(:recipe).permit(:name, :description)
    end

end