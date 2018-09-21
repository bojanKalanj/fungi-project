class UsersController < ApplicationController
  def show
    @user = User.friendly.find(params[:id])
  end

  def edit
    @user = User.friendly.find(params[:id])
  end

  def update
    @user = User.friendly.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to root_path
      flash[:notice] = "Uspesno ste izmenili profil..."
    else
      flash[:danger] = "Ne valja ti poso"
    end
  end

  private

  def user_params
    params.require(:user).permit(User::PUBLIC_FIELDS)
  end
end
