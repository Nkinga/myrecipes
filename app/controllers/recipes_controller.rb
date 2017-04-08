class RecipesController < ApplicationController
  before_action :set_recipe, only: [:edit, :show, :update, :destroy, :upvote, :downvote]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  
  def index
    @recipes = Recipe.paginate(page: params[:page], per_page: 5)
  end
  
  def show
    @comment = Comment.new
    @comments = @recipe.comments.paginate(page: params[:page], per_page: 5)
  end
  
  def new
    @recipe = Recipe.new
  end
  
  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.chef = current_chef
    
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
  
  def upvote
    @recipe.upvote_by current_chef
    flash[:success] = "Successfully liked"
    respond_to do |format|
      format.html {redirect_to recipes_path }
      format.json { render json: { count: @recipe.liked_count } }
    end
  end
  
  def downvote
    @recipe.downvote_by current_chef
    flash[:success] = "Successfully disliked"
    respond_to do |format|
      format.html {redirect_to recipes_path }
      format.json { render json: { count: @recipe.disliked_count } }
    end
  end
  
  private
    
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end
  
    def recipe_params
      params.require(:recipe).permit(:name, :description, ingredient_ids: [])
    end
    
    def require_same_user
      if current_chef != @recipe.chef and !current_chef.admin?
        flash[:danger] = "You can only edit or delete your own recipes"
        redirect_to recipes_path
      end
    end

end