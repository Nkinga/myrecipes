class ChefsController < ApplicationController
  
  def new
    @chef = Chef.new
  end
  
  def create
    @chef = Chef.new(chef_params)
    if @chef.save
      flash[:success] = "Welcome #{@chef.chefname} to MyRecipes App!"
      redirect_to chef_path(@chef)
    else
      render 'new'
    end
  end
  
  def show
    @chef = Chef.find(params[:id])
    @chef_recipes = @chef.recipes.paginate(page: params[:page], per_page: 5)
  end
  
  def index 
    @chefs = Chef.paginate(page: params[:page], per_page: 5)
  end
  
  def edit
    @chef = Chef.find(params[:id])
  end
  
  def update
    @chef = Chef.find(params[:id])
    if @chef.update(chef_params)
      flash[:notice] = "Your account was successfully updated"
      redirect_to @chef
    else
      render 'edit'
    end 
  end
  
  def destroy
    @chef.destroy
      flash[:notice] = "Recipe was successfully deleted." 
      redirect_to chefs_path
  end

  private
  
  def chef_params
    params.require(:chef).permit(:chefname, :email, 
                                    :password, :password_confirmation)
  end
end